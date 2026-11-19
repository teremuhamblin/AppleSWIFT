import Foundation

public enum DeviceIdentifierDB {
    private static let knownModels: [String: String] = [
        // iPhone récents
        "iPhone14,2": "iPhone 13 Pro",
        "iPhone14,3": "iPhone 13 Pro Max",
        "iPhone14,4": "iPhone 13 mini",
        "iPhone14,5": "iPhone 13",
        "iPhone14,6": "iPhone SE (3e gén.)",
        "iPhone14,7": "iPhone 14",
        "iPhone14,8": "iPhone 14 Plus",
        "iPhone15,2": "iPhone 14 Pro",
        "iPhone15,3": "iPhone 14 Pro Max",
        "iPhone15,4": "iPhone 15",
        "iPhone15,5": "iPhone 15 Plus",
        "iPhone16,1": "iPhone 15 Pro",
        "iPhone16,2": "iPhone 15 Pro Max",
        "iPhone17,1": "iPhone 16 Pro",
        "iPhone17,2": "iPhone 16 Pro Max",
        "iPhone17,3": "iPhone 16",
        "iPhone17,4": "iPhone 16 Plus",
        // Mac Apple Silicon courants
        "Mac14,2": "MacBook Air (M2, 2022)",
        "Mac14,3": "Mac mini (M2, 2023)",
        "Mac14,7": "MacBook Pro 13\" (M2, 2022)",
        "Mac14,9": "MacBook Pro 14\" (M2 Pro/Max, 2023)",
        "Mac15,3": "MacBook Pro 14\" (M3, 2023)",
        "Mac15,12": "MacBook Air 13\" (M3, 2024)",
        "Mac15,13": "MacBook Air 15\" (M3, 2024)",
        "Mac16,1": "MacBook Pro 14\" (M4, 2024)"
    ]

    public static func resolve(_ rawIdentifier: String) -> String {
        if let match = knownModels[rawIdentifier] {
            return match
        }
        if rawIdentifier == "arm64" || rawIdentifier == "x86_64" {
            if let simID = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] {
                return "\(knownModels[simID] ?? simID) (Simulateur)"
            }
        }
        return rawIdentifier
    }
}
