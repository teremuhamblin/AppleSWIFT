public struct PhoneValidationResult: Sendable, Equatable {
    public let isValid: Bool
    public let normalized: String?
    public let masked: String
}

public struct NumberValidator: Sendable {
    public init() {}

    public func validate(_ rawInput: String) -> PhoneValidationResult {
        // 1. Garde-fou O(1) contre les chaînes anormalement longues
        guard rawInput.utf8.count <= 64 else {
            return PhoneValidationResult(isValid: false, normalized: nil, masked: "***")
        }

        // 2. Normalisation légère (suppression espaces et retours à la ligne)
        let cleaned = rawInput.filter { !$0.isWhitespace && !$0.isNewline }
        guard !cleaned.isEmpty else {
            return PhoneValidationResult(isValid: false, normalized: nil, masked: "***")
        }

        // 3. Vérification stricte E.164 basique : '+' optionnel + 7 à 15 chiffres ASCII
        let digits = cleaned.hasPrefix("+") ? cleaned.dropFirst() : Substring(cleaned)
        let isOnlyASCIIDigits = digits.allSatisfy { $0.isASCII && $0.isNumber }

        guard isOnlyASCIIDigits, (7...15).contains(digits.count) else {
            return PhoneValidationResult(isValid: false, normalized: nil, masked: "***")
        }

        // 4. Masquage RGPD pour affichage ou logging sécurisé
        let visiblePrefix = cleaned.count >= 8 ? 4 : 2
        let hiddenCount = max(1, cleaned.count - visiblePrefix - 2)
        let masked = "\(cleaned.prefix(visiblePrefix))\(String(repeating: "*", count: hiddenCount))\(cleaned.suffix(2))"

        return PhoneValidationResult(
            isValid: true,
            normalized: cleaned,
            masked: masked
        )
    }
}
