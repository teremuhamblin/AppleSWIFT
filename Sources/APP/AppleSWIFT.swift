public struct AppleSWIFT: Sendable {
    private let modelParser: ModelParser
    private let numberValidator: NumberValidator

    public init(
        modelParser: ModelParser = ModelParser(),
        numberValidator: NumberValidator = NumberValidator()
    ) {
        self.modelParser = modelParser
        self.numberValidator = numberValidator
    }

    /// Valide et normalise un numéro de téléphone avec masquage sécurisé pour les logs.
    public func validateNumber(_ rawInput: String) -> PhoneValidationResult {
        numberValidator.validate(rawInput)
    }

    /// Extrait la marque et le modèle à partir d'une chaîne brute.
    public func parseModel(_ rawInput: String) -> ModelInfo {
        modelParser.parse(rawInput)
    }

    /// Formate proprement le nom d'un appareil (espaces normalisés).
    public func formatModel(_ rawInput: String) -> String {
        modelParser.parse(rawInput).formatted
    }
}
