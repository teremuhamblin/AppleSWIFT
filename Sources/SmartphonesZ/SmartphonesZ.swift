public struct PhoneCheck {
    public let raw: String
    public let isValid: Bool
}

public struct ModelInfo {
    public let brand: String
    public let model: String
}

public final class SmartphonesZ {

    public init() {}

    // Validation très simple : commence par + et contient au moins 8 chiffres
    public func validateNumber(_ input: String) -> PhoneCheck {
        let digits = input.filter { $0.isNumber }
        let valid = input.starts(with: "+") && digits.count >= 8
        return PhoneCheck(raw: input, isValid: valid)
    }

    // Extraction naïve marque + modèle
    public func parseModel(_ input: String) -> ModelInfo {
        let parts = input.split(separator: " ")
        let brand = parts.first.map(String.init) ?? "Unknown"
        let model = parts.dropFirst().joined(separator: " ")
        return ModelInfo(brand: brand, model: model)
    }
}
