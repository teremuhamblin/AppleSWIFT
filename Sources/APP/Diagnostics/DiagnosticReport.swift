import Foundation

public struct DiagnosticAlert: Sendable, Codable, Equatable {
    public let level: String
    public let message: String
}

public struct DiagnosticReport: Sendable, Codable, Equatable {
    public let frameworkVersion: String
    public let timestampISO8601: String
    public let healthScore: Int
    public let system: SystemSnapshot
    public let network: NetworkSnapshot
    public let alerts: [DiagnosticAlert]

    public static func generate(system: SystemSnapshot, network: NetworkSnapshot) -> DiagnosticReport {
        var score = 100
        var alerts: [DiagnosticAlert] = []

        if system.storageUsedPercent >= 90 {
            score -= 25
            alerts.append(DiagnosticAlert(level: "CRITIQUE", message: "Stockage presque saturé (\(system.storageUsedPercent)% utilisé)."))
        } else if system.storageUsedPercent >= 80 {
            score -= 10
            alerts.append(DiagnosticAlert(level: "ATTENTION", message: "Espace disque faible (\(system.storageAvailableGB) Go restants)."))
        }

        if system.thermalState == "Élevé" || system.thermalState == "Critique" {
            score -= 20
            alerts.append(DiagnosticAlert(level: "ALERTE", message: "Température élevée (\(system.thermalState)) : risque de bridage CPU."))
        }

        if let battery = system.battery, battery.levelPercent <= 15 && !battery.isCharging {
            score -= 10
            alerts.append(DiagnosticAlert(level: "INFO", message: "Batterie faible (\(battery.levelPercent)%) et non branchée."))
        }

        if !network.isConnected {
            score -= 15
            alerts.append(DiagnosticAlert(level: "ATTENTION", message: "Aucune connectivité réseau active détectée."))
        }

        if alerts.isEmpty {
            alerts.append(DiagnosticAlert(level: "OK", message: "Tous les indicateurs système et réseau sont sains."))
        }

        let formatter = ISO8601DateFormatter()
        return DiagnosticReport(
            frameworkVersion: "1.2.0",
            timestampISO8601: formatter.string(from: Date()),
            healthScore: max(0, score),
            system: system,
            network: network,
            alerts: alerts
        )
    }

    public func toJSON(pretty: Bool = true) -> String? {
        let encoder = JSONEncoder()
        if pretty {
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        }
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    public func formattedText() -> String {
        var lines: [String] = [
            "==================================================",
            "🌌 AppleSWIFT v\(frameworkVersion) — RAPPORT DE DIAGNOSTIC",
            "==================================================",
            "🕒 Date        : \(timestampISO8601)",
            "💚 Score Santé : \(healthScore)/100",
            "",
            "📱 APPAREIL & SYSTÈME",
            "  • Modèle     : \(system.deviceName) [\(system.deviceIdentifier)]",
            "  • OS         : \(system.osName) — \(system.osVersion)",
            "  • CPU / RAM  : \(system.activeCores)/\(system.cpuCores) cœurs | \(system.totalMemoryGB) Go RAM",
            "  • Stockage   : \(system.storageAvailableGB) Go libres / \(system.storageTotalGB) Go (\(system.storageUsedPercent)% utilisé)",
            "  • Thermique  : \(system.thermalState) | Éco. énergie : \(system.isLowPowerMode ? "Oui" : "Non")",
            "  • Uptime     : \(system.uptimeHours) h"
        ]

        if let battery = system.battery {
            lines.append("  • Batterie   : \(battery.levelPercent)% (\(battery.isCharging ? "En charge" : "Sur batterie") — \(battery.powerSource))")
        } else {
            lines.append("  • Batterie   : Non applicable (alimentation secteur / Mac fixe)")
        }

        lines.append("")
        lines.append("🌐 RÉSEAU")
        lines.append("  • Statut     : \(network.isConnected ? "Connecté" : "Hors ligne") (\(network.interfaceType))")
        lines.append("  • IPv4/IPv6  : IPv4=\(network.supportsIPv4 ? "Oui" : "Non") | IPv6=\(network.supportsIPv6 ? "Oui" : "Non")")
        lines.append("  • Mode éco   : \(network.isLowDataMode ? "Activé" : "Désactivé") | Coûteux : \(network.isExpensive ? "Oui" : "Non")")

        lines.append("")
        lines.append("🩺 DIAGNOSTIC & ALERTES")
        for alert in alerts {
            lines.append("  [\(alert.level)] \(alert.message)")
        }
        lines.append("==================================================")
        return lines.joined(separator: "\n")
    }
}
