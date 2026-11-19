import SwiftUI

/// Shows the login gate first; after authentication shows the navigation stack.
struct RootView: View {
    let repository: TopicRepository
    @ObservedObject var auth: AuthViewModel

    var body: some View {
        if auth.isAuthenticated {
            NavigationStack {
                DashboardView(repository: repository)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .list:
                            TopicListView(repository: repository)
                        case .detail(let id):
                            TopicDetailView(repository: repository, topicID: id)
                        case .form(let id):
                            TopicFormView(repository: repository, topicID: id)
                        }
                    }
            }
        } else {
            AuthView(vm: auth)
        }
    }
}
