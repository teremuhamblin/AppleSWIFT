import Foundation
import Network

public struct NetworkSnapshot: Sendable, Codable, Equatable {
    public let isConnected: Bool
    public let interfaceType: String
    public let isExpensive: Bool
    public let isLowDataMode: Bool
    public let supportsIPv4: Bool
    public let supportsIPv6: Bool
}

public struct NetworkDiagnostics: Sendable {
    public init() {}

    public func collect() async -> NetworkSnapshot {
        await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "com.appleswift.network.diag")
            let box = ContinuationBox(continuation)

            monitor.pathUpdateHandler = { path in
                monitor.cancel()
                let snapshot = NetworkSnapshot(
                    isConnected: path.status == .satisfied,
                    interfaceType: Self.detectInterface(path),
                    isExpensive: path.isExpensive,
                    isLowDataMode: path.isConstrained,
                    supportsIPv4: path.supportsIPv4,
                    supportsIPv6: path.supportsIPv6
                )
                box.resume(returning: snapshot)
            }

            monitor.start(queue: queue)

            // Timeout de sécurité (2 secondes) pour ne jamais bloquer le diagnostic
            queue.asyncAfter(deadline: .now() + 2.0) {
                monitor.cancel()
                box.resume(returning: NetworkSnapshot(
                    isConnected: false,
                    interfaceType: "Délai dépassé / Indisponible",
                    isExpensive: false,
                    isLowDataMode: false,
                    supportsIPv4: false,
                    supportsIPv6: false
                ))
            }
        }
    }

    private static func detectInterface(_ path: NWPath) -> String {
        if path.usesInterfaceType(.wifi) { return "Wi-Fi" }
        if path.usesInterfaceType(.cellular) { return "Cellulaire" }
        if path.usesInterfaceType(.wiredEthernet) { return "Ethernet" }
        if path.usesInterfaceType(.loopback) { return "Loopback" }
        return path.status == .satisfied ? "Autre" : "Aucune"
    }
}

private final class ContinuationBox<T: Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var continuation: CheckedContinuation<T, Never>?

    init(_ continuation: CheckedContinuation<T, Never>) {
        self.continuation = continuation
    }

    func resume(returning value: T) {
        lock.lock()
        let cont = continuation
        continuation = nil
        lock.unlock()
        cont?.resume(returning: value)
    }
}
