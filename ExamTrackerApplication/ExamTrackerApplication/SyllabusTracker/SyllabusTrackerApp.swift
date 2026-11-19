import SwiftUI

/// App entry point. Owns the two long-lived objects: the data layer and the auth state.
@main
struct SyllabusTrackerApp: App {
    @StateObject private var repository = TopicRepository()
    @StateObject private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView(repository: repository, auth: auth)
        }
    }
}
