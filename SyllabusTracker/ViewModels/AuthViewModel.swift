import Foundation

/// Authentication state: Face ID result handling + manual login validation.
final class AuthViewModel: ObservableObject {
    @Published var username = "" { didSet { usernameError = nil; errorMessage = nil } }
    @Published var password = "" { didSet { passwordError = nil; errorMessage = nil } }
    @Published private(set) var showManualLogin = false
    @Published private(set) var infoMessage: String?
    @Published private(set) var errorMessage: String?
    @Published private(set) var usernameError: String?
    @Published private(set) var passwordError: String?
    @Published private(set) var isAuthenticated = false

    private let biometric = BiometricService()
    private var biometricPrompted = false

    /// True only once, so Face ID opens automatically at launch and not on every re-render.
    func shouldPromptBiometric() -> Bool {
        if biometricPrompted { return false }
        biometricPrompted = true
        return true
    }

    @MainActor
    func authenticateWithBiometrics() async {
        handle(await biometric.authenticate())
    }

    func login() {
        usernameError = CredentialValidator.validateUsername(username)
        passwordError = CredentialValidator.validatePassword(password)
        guard usernameError == nil, passwordError == nil else { return }

        if CredentialValidator.isValid(username: username, password: password) {
            isAuthenticated = true
        } else {
            errorMessage = "Invalid username or password. Please try again."
        }
    }

    private func handle(_ result: BiometricResult) {
        switch result {
        case .success:
            isAuthenticated = true
        case .unavailable:
            showManualLogin = true
            infoMessage = "Face ID is not available on this device. Please sign in manually."
        case .cancelled:
            showManualLogin = true
            infoMessage = "Face ID skipped. Please sign in with your credentials."
        case .failure(let message):
            showManualLogin = true
            errorMessage = "Face ID failed (\(message)). Please sign in manually."
        }
    }
}
