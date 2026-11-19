import Foundation

/// Local (offline) credential rules for the manual-login fallback.
enum CredentialValidator {
    static let demoUsername = "student"
    static let demoPassword = "exam123"

    static func validateUsername(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "Username is required" }
        if trimmed.count < 3 { return "Username must be at least 3 characters" }
        return nil
    }

    static func validatePassword(_ value: String) -> String? {
        if value.isEmpty { return "Password is required" }
        if value.count < 6 { return "Password must be at least 6 characters" }
        return nil
    }

    static func isValid(username: String, password: String) -> Bool {
        username.trimmingCharacters(in: .whitespaces) == demoUsername && password == demoPassword
    }
}
