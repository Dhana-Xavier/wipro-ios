import Foundation

/// Backend data layer and single source of truth for topics.
/// Persists to a JSON file in the Documents folder. Every ViewModel observes `topics`,
/// so any add / edit / delete is reflected on all screens immediately.
final class TopicRepository: ObservableObject {
    @Published private(set) var topics: [Topic]
    private let fileURL: URL

    init(fileName: String = "topics.json") {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = directory.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            topics = Self.load(from: fileURL)
        } else {
            topics = Self.sampleTopics()   // first launch only
            save()
        }
    }

    func topic(withID id: UUID) -> Topic? {
        topics.first { $0.id == id }
    }

    func add(_ topic: Topic) {
        topics.append(topic)
        save()
    }

    func update(_ topic: Topic) {
        guard let index = topics.firstIndex(where: { $0.id == topic.id }) else { return }
        topics[index] = topic
        save()
    }

    func delete(id: UUID) {
        topics.removeAll { $0.id == id }
        save()
    }

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(topics)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save topics: \(error)")
        }
    }

    private static func load(from url: URL) -> [Topic] {
        guard let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Topic].self, from: data) else { return [] }
        return decoded
    }

    private static func sampleTopics() -> [Topic] {
        [
            Topic(name: "Inheritance & Polymorphism", subject: "Java", unit: "Unit 2", importance: .high, stage: .firstRevision, notes: "Overriding vs overloading"),
            Topic(name: "Exception Handling", subject: "Java", unit: "Unit 3", importance: .medium, stage: .notStarted, notes: ""),
            Topic(name: "Normalization (1NF-BCNF)", subject: "Database Systems", unit: "Unit 2", importance: .high, stage: .secondRevision, notes: "Functional dependencies"),
            Topic(name: "SQL Joins", subject: "Database Systems", unit: "Unit 3", importance: .medium, stage: .completed, notes: "INNER, LEFT, RIGHT, FULL"),
            Topic(name: "React Hooks", subject: "Web Technology", unit: "Unit 4", importance: .high, stage: .notStarted, notes: "useState, useEffect, useMemo"),
            Topic(name: "REST API Design", subject: "Web Technology", unit: "Unit 5", importance: .low, stage: .notStarted, notes: "")
        ]
    }
}
