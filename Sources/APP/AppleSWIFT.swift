public struct AppleSWIFT: Sendable {
    private let modelParser: ModelParser
    private let numberValidator: NumberValidator
    private let systemDiagnostics: SystemDiagnostics
    private let networkDiagnostics: NetworkDiagnostics

    public init(
        modelParser: ModelParser = ModelParser(),
        numberValidator: NumberValidator = NumberValidator(),
        systemDiagnostics: SystemDiagnostics = SystemDiagnostics(),
        networkDiagnostics: NetworkDiagnostics = NetworkDiagnostics()
    ) {
        self.modelParser = modelParser
        self.numberValidator = numberValidator
        self.systemDiagnostics = systemDiagnostics
        self.networkDiagnostics = networkDiagnostics
    }

    // MARK: - Fonctions v1.1.0 (Rétrocompatibles)

    public func validateNumber(_ rawInput: String) -> PhoneValidationResult {
        numberValidator.validate(rawInput)
    }

    public func parseModel(_ rawInput: String) -> ModelInfo {
        modelParser.parse(rawInput)
    }

    public func formatModel(_ rawInput: String) -> String {
        modelParser.parse(rawInput).formatted
    }

    // MARK: - Moteur de diagnostic v1.2.0 (iOS & macOS)

    public func runDiagnostics() async -> DiagnosticReport {
        async let system = systemDiagnostics.collect()
        async let network = networkDiagnostics.collect()
        return await DiagnosticReport.generate(system: system, network: network)
    }
}
