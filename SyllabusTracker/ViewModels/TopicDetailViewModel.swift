import Foundation

/// Observes one topic; supports moving its stage forward and deleting it.
final class TopicDetailViewModel: ObservableObject {
    @Published private(set) var topic: Topic?

    private let repository: TopicRepository
    private let topicID: UUID

    init(repository: TopicRepository, topicID: UUID) {
        self.repository = repository
        self.topicID = topicID
        repository.$topics
            .map { $0.first { $0.id == topicID } }
            .assign(to: &$topic)
    }

    func advanceStage() {
        guard var current = topic, let next = current.stage.next else { return }
        current.stage = next
        repository.update(current)
    }

    func delete() {
        repository.delete(id: topicID)
    }
}
