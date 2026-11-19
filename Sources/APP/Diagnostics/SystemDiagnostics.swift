import Foundation
import Darwin

#if os(iOS)
import UIKit
#endif

#if os(macOS)
import IOKit.ps
#endif

public struct BatterySnapshot: Sendable, Codable, Equatable {
    public let levelPercent: Int
    public let isCharging: Bool
    public let powerSource: String
}

public struct SystemSnapshot: Sendable, Codable, Equatable {
    public let deviceIdentifier: String
    public let deviceName: String
    public let osName: String
    public let osVersion: String
    public let cpuCores: Int
    public let activeCores: Int
    public let totalMemoryGB: Double
    public let storageTotalGB: Double
    public let storageAvailableGB: Double
    public let storageUsedPercent: Double
    public let thermalState: String
    public let isLowPowerMode: Bool
    public let uptimeHours: Double
    public let battery: BatterySnapshot?
}

public struct SystemDiagnostics: Sendable {
    public init() {}

    public func collect() async -> SystemSnapshot {
        let info = ProcessInfo.processInfo
        let identifier = currentHardwareIdentifier()
        let deviceName = DeviceIdentifierDB.resolve(identifier)
        let storage = readStorageMetrics()
        let battery = await readBatteryMetrics()

        #if os(iOS)
        let osName = "iOS"
        #elseif os(macOS)
        let osName = "macOS"
        #elseif os(tvOS)
        let osName = "tvOS"
        #elseif os(watchOS)
        let osName = "watchOS"
        #elseif os(visionOS)
        let osName = "visionOS"
        #else
        let osName = "AppleOS"
        #endif

        return SystemSnapshot(
            deviceIdentifier: identifier,
            deviceName: deviceName,
            osName: osName,
            osVersion: info.operatingSystemVersionString,
            cpuCores: info.processorCount,
            activeCores: info.activeProcessorCount,
            totalMemoryGB: roundTo2(Double(info.physicalMemory) / 1_073_741_824.0),
            storageTotalGB: storage.totalGB,
            storageAvailableGB: storage.availableGB,
            storageUsedPercent: storage.usedPercent,
            thermalState: formatThermalState(info.thermalState),
            isLowPowerMode: info.isLowPowerModeEnabled,
            uptimeHours: roundTo2(info.systemUptime / 3600.0),
            battery: battery
        )
    }

    private func currentHardwareIdentifier() -> String {
        #if os(macOS)
        var size: size_t = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        if size > 0 {
            var model = [CChar](repeating: 0, count: Int(size))
            if sysctlbyname("hw.model", &model, &size, nil, 0) == 0 {
                return String(cString: model)
            }
        }
        #endif

        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce(into: "") { result, element in
            guard let value = element.value as? Int8, value != 0 else { return }
            result.append(Character(UnicodeScalar(UInt8(value))))
        }
    }

    private func readStorageMetrics() -> (totalGB: Double, availableGB: Double, usedPercent: Double) {
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        let keys: Set<URLResourceKey> = [
            .volumeTotalCapacityKey,
            .volumeAvailableCapacityForImportantUsageKey
        ]

        guard let values = try? homeURL.resourceValues(forKeys: keys),
              let totalBytes = values.volumeTotalCapacity,
              let availBytes = values.volumeAvailableCapacityForImportantUsage,
              totalBytes > 0 else {
            return (0, 0, 0)
        }

        let totalGB = Double(totalBytes) / 1_000_000_000.0
        let availGB = Double(availBytes) / 1_000_000_000.0
        let usedPct = max(0, min(100, ((totalGB - availGB) / totalGB) * 100.0))

        return (roundTo2(totalGB), roundTo2(availGB), roundTo2(usedPct))
    }

    private func readBatteryMetrics() async -> BatterySnapshot? {
        #if os(iOS)
        return await MainActor.run {
            let device = UIDevice.current
            let wasEnabled = device.isBatteryMonitoringEnabled
            device.isBatteryMonitoringEnabled = true
            defer { device.isBatteryMonitoringEnabled = wasEnabled }

            let rawLevel = device.batteryLevel
            guard rawLevel >= 0 else { return nil }

            let isCharging = (device.batteryState == .charging || device.batteryState == .full)
            return BatterySnapshot(
                levelPercent: Int((rawLevel * 100).rounded()),
                isCharging: isCharging,
                powerSource: isCharging ? "Secteur / USB" : "Batterie"
            )
        }
        #elseif os(macOS)
        guard let info = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let list = IOPSCopyPowerSourcesList(info)?.takeRetainedValue() as? [CFTypeRef] else {
            return nil
        }

        for source in list {
            guard let desc = IOPSGetPowerSourceDescription(info, source)?.takeUnretainedValue() as? [String: Any] else {
                continue
            }
            if let current = desc[kIOPSCurrentCapacityKey] as? Int,
               let maxCap = desc[kIOPSMaxCapacityKey] as? Int,
               maxCap > 0 {
                let percent = Int((Double(current) / Double(maxCap) * 100.0).rounded())
                let isCharging = (desc[kIOPSIsChargingKey] as? Bool) ?? false
                let state = (desc[kIOPSPowerSourceStateKey] as? String) ?? "Inconnu"
                return BatterySnapshot(
                    levelPercent: percent,
                    isCharging: isCharging,
                    powerSource: state
                )
            }
        }
        return nil
        #else
        return nil
        #endif
    }

    private func formatThermalState(_ state: ProcessInfo.ThermalState) -> String {
        switch state {
        case .nominal: return "Nominal"
        case .fair: return "Modéré"
        case .serious: return "Élevé"
        case .critical: return "Critique"
        @unknown default: return "Inconnu"
        }
    }

    private func roundTo2(_ value: Double) -> Double {
        (value * 100).rounded() / 100
    }
}
