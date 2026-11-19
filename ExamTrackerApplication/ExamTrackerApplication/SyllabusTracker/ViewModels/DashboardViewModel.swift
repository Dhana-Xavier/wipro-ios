import Combine
import Foundation

/// Live dashboard statistics derived from the repository.
final class DashboardViewModel: ObservableObject {
    @Published private(set) var stats = DashboardStats()

    init(repository: TopicRepository) {
        repository.$topics
            .map { DashboardStats(topics: $0) }
            .assign(to: &$stats)
    }
}
