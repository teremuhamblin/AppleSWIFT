import AppleSWIFT
import Foundation

@main
struct AppleSWIFTCLI {
    static func main() async {
        let args = Array(CommandLine.arguments.dropFirst())
        let framework = AppleSWIFT()

        if args.contains("--help") || args.contains("-h") {
            printHelp()
            return
        }

        if let index = args.firstIndex(of: "--device"), index + 1 < args.count {
            let rawID = args[index + 1]
            let resolved = DeviceIdentifierDB.resolve(rawID)
            let parsed = framework.parseModel(resolved)
            print("📱 Identifiant : \(rawID)")
            print("🔎 Modèle      : \(resolved) (Marque: \(parsed.brand))")
            return
        }

        if let index = args.firstIndex(of: "--phone"), index + 1 < args.count {
            let result = framework.validateNumber(args[index + 1])
            print("📞 Valide  : \(result.isValid)")
            print("🔒 Masqué  : \(result.masked)")
            if let normalized = result.normalized {
                print("✨ Normalisé : \(normalized)")
            }
            return
        }

        let report = await framework.runDiagnostics()

        if args.contains("--json") {
            print(report.toJSON() ?? "{}")
        } else {
            print(report.formattedText())
        }
    }

    private static func printHelp() {
        print("""
        🌌 AppleSWIFT Diagnostic CLI (v1.2.0)

        Usage:
          swift run appleswift-diag                 Lance un diagnostic complet (texte)
          swift run appleswift-diag --json          Exporte le rapport au format JSON
          swift run appleswift-diag --device ID     Identifie un modèle (ex: iPhone16,1)
          swift run appleswift-diag --phone NUM     Valide et masque un numéro (RGPD)
          swift run appleswift-diag --help          Affiche cette aide
        """)
    }
}
