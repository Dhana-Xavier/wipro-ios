import Foundation

/// Aggregated numbers for the dashboard (pure logic, easy to test).
struct DashboardStats {
    var totalTopics = 0
    var completedTopics = 0
    var pendingTopics = 0
    var subjectWithMostPending: String?
    var mostPendingCount = 0
    var stageCounts: [RevisionStage: Int] = [:]

    var completionFraction: Double {
        totalTopics == 0 ? 0 : Double(completedTopics) / Double(totalTopics)
    }

    init() {}

    init(topics: [Topic]) {
        let pending = topics.filter { !$0.stage.isCompleted }
        totalTopics = topics.count
        completedTopics = topics.count - pending.count
        pendingTopics = pending.count
        stageCounts = Dictionary(uniqueKeysWithValues: RevisionStage.allCases.map { stage in
            (stage, topics.filter { $0.stage == stage }.count)
        })

        let perSubject = Dictionary(grouping: pending, by: \.subject).mapValues(\.count)
        // Highest count wins; ties are broken alphabetically so the result is stable.
        let best = perSubject.max { a, b in
            a.value != b.value ? a.value < b.value : a.key > b.key
        }
        subjectWithMostPending = best?.key
        mostPendingCount = best?.value ?? 0
    }
}
