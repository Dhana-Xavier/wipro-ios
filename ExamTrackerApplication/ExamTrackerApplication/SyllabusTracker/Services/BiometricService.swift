import LocalAuthentication

/// Outcome of a Face ID attempt.
enum BiometricResult: Equatable {
    case success
    case unavailable
    case cancelled
    case failure(String)
}

/// Wraps LocalAuthentication (Face ID / Touch ID).
struct BiometricService {
    func authenticate() async -> BiometricResult {
        let context = LAContext()
        context.localizedFallbackTitle = "Use manual login"

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .unavailable
        }
        do {
            let ok = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Unlock your syllabus tracker"
            )
            return ok ? .success : .failure("Authentication failed")
        } catch let laError as LAError {
            switch laError.code {
            case .userCancel, .userFallback, .systemCancel, .appCancel:
                return .cancelled
            default:
                return .failure(laError.localizedDescription)
            }
        } catch {
            return .failure(error.localizedDescription)
        }
    }
}
