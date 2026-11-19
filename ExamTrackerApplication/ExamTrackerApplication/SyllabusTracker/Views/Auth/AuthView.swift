import SwiftUI

/// Launch screen: tries Face ID automatically, falls back to manual login.
struct AuthView: View {
    @ObservedObject var vm: AuthViewModel
    @State private var showPassword = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Spacer(minLength: 60)
                Image(systemName: "faceid")
                    .font(.system(size: 64))
                    .foregroundColor(.accentColor)
                Text("Exam Syllabus Tracker").font(.title2.bold())

                if vm.showManualLogin {
                    manualLogin
                } else {
                    ProgressView()
                    Text("Waiting for Face ID…").foregroundColor(.secondary)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .task {
            if vm.shouldPromptBiometric() {
                await vm.authenticateWithBiometrics()
            }
        }
    }

    private var manualLogin: some View {
        VStack(spacing: 12) {
            if let info = vm.infoMessage {
                Text(info).font(.subheadline).multilineTextAlignment(.center)
            }
            if let error = vm.errorMessage {
                Text(error).font(.subheadline).foregroundColor(.red).multilineTextAlignment(.center)
            }

            TextField("Username", text: $vm.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            fieldError(vm.usernameError)

            HStack {
                Group {
                    if showPassword {
                        TextField("Password", text: $vm.password)
                    } else {
                        SecureField("Password", text: $vm.password)
                    }
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                Button(showPassword ? "Hide" : "Show") { showPassword.toggle() }
            }
            fieldError(vm.passwordError)

            Button {
                vm.login()
            } label: {
                Text("Sign in").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button("Try Face ID again") {
                Task { await vm.authenticateWithBiometrics() }
            }

            Text("Demo login: \(CredentialValidator.demoUsername) / \(CredentialValidator.demoPassword)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    @ViewBuilder
    private func fieldError(_ message: String?) -> some View {
        if let message {
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
