import Foundation

/// How important a topic is for the exam.
enum Importance: String, Codable, CaseIterable, Identifiable {
    case low, medium, high
    var id: String { rawValue }
    var label: String { rawValue.capitalized }
}

/// Revision pipeline: Not Started -> First -> Second -> Completed.
enum RevisionStage: Int, Codable, CaseIterable, Identifiable, Comparable {
    case notStarted = 0, firstRevision, secondRevision, completed

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .notStarted: return "Not Started"
        case .firstRevision: return "First Revision"
        case .secondRevision: return "Second Revision"
        case .completed: return "Completed"
        }
    }

    var isCompleted: Bool { self == .completed }

    /// The following stage, or `nil` when already completed.
    var next: RevisionStage? { RevisionStage(rawValue: rawValue + 1) }

    static func < (lhs: RevisionStage, rhs: RevisionStage) -> Bool { lhs.rawValue < rhs.rawValue }
}

/// Subjects offered in the form and in the filter bar.
enum Subjects {
    static let all = [
        "Java", "Database Systems", "Web Technology",
        "Data Structures", "Operating Systems", "Computer Networks"
    ]
}

/// One syllabus topic.
struct Topic: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var subject: String
    var unit: String
    var importance: Importance
    var stage: RevisionStage
    var notes: String
}
