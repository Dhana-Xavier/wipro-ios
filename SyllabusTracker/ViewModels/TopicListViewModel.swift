import Combine
import Foundation

/// Topic list with search (by name) and filters (subject, revision stage).
final class TopicListViewModel: ObservableObject {
    @Published var query = ""
    @Published var subjectFilter: String?
    @Published var stageFilter: RevisionStage?
    @Published private(set) var topics: [Topic] = []

    private let repository: TopicRepository

    init(repository: TopicRepository) {
        self.repository = repository
        Publishers.CombineLatest4(repository.$topics, $query, $subjectFilter, $stageFilter)
            .map { all, query, subject, stage in
                let text = query.trimmingCharacters(in: .whitespaces)
                return all.filter { topic in
                    (text.isEmpty || topic.name.localizedCaseInsensitiveContains(text))
                        && (subject == nil || topic.subject == subject)
                        && (stage == nil || topic.stage == stage)
                }
            }
            .assign(to: &$topics)
    }

    func delete(_ topic: Topic) {
        repository.delete(id: topic.id)
    }
}
