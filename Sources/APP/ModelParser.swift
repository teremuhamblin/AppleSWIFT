public struct ModelInfo: Sendable, Equatable {
    public let brand: String
    public let model: String

    public var formatted: String {
        model.isEmpty ? brand : "\(brand) \(model)"
    }

    public var isValid: Bool {
        !brand.isEmpty
    }
}

public struct ModelParser: Sendable {
    public init() {}

    public func parse(_ rawInput: String) -> ModelInfo {
        // Garde-fou O(1) contre les entrées anormalement longues
        guard rawInput.utf8.count <= 128 else {
            return ModelInfo(brand: "", model: "")
        }

        let tokens = rawInput.split(whereSeparator: { $0.isWhitespace || $0.isNewline })
        guard let firstToken = tokens.first else {
            return ModelInfo(brand: "", model: "")
        }

        let brand = String(firstToken)
        let model = tokens.dropFirst().joined(separator: " ")

        return ModelInfo(brand: brand, model: model)
    }
}
