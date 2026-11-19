import Combine
import Foundation

/// Shared by Add Topic (`topicID == nil`) and Edit Topic.
final class TopicFormViewModel: ObservableObject {
    @Published var name = "" { didSet { nameError = nil } }
    @Published var subject = Subjects.all[0]
    @Published var unit = "" { didSet { unitError = nil } }
    @Published var importance = Importance.medium
    @Published var stage = RevisionStage.notStarted
    @Published var notes = ""
    @Published private(set) var nameError: String?
    @Published private(set) var unitError: String?

    let isEditing: Bool
    private let editingID: UUID?
    private let minStage: RevisionStage
    private let repository: TopicRepository

    /// In edit mode the revision stage can only move forward.
    var availableStages: [RevisionStage] {
        RevisionStage.allCases.filter { $0 >= minStage }
    }

    init(repository: TopicRepository, topicID: UUID?) {
        self.repository = repository
        let existing = topicID.flatMap { repository.topic(withID: $0) }
        self.editingID = existing?.id
        self.isEditing = existing != nil
        self.minStage = existing?.stage ?? .notStarted
        if let topic = existing {
            name = topic.name
            subject = topic.subject
            unit = topic.unit
            importance = topic.importance
            stage = topic.stage
            notes = topic.notes
        }
    }

    /// Validates and stores the topic. Returns `true` when saved.
    func save() -> Bool {
        nameError = name.trimmingCharacters(in: .whitespaces).isEmpty ? "Topic name is required" : nil
        unitError = unit.trimmingCharacters(in: .whitespaces).isEmpty ? "Unit is required" : nil
        guard nameError == nil, unitError == nil else { return false }

        let topic = Topic(
            id: editingID ?? UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            subject: subject,
            unit: unit.trimmingCharacters(in: .whitespaces),
            importance: importance,
            stage: stage,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        if editingID == nil {
            repository.add(topic)
        } else {
            repository.update(topic)
        }
        return true
    }
}
