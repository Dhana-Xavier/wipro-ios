import SwiftUI

/// Rounded "card" background used across screens.
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardStyle()) }
}

/// Number card used on the dashboard.
struct StatCard: View {
    let label: String
    let value: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)").font(.title.bold())
            Text(label).font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

/// Colored pill that shows a revision stage.
struct StageBadge: View {
    let stage: RevisionStage

    private var color: Color {
        switch stage {
        case .notStarted: return .gray
        case .firstRevision: return .orange
        case .secondRevision: return .blue
        case .completed: return .green
        }
    }

    var body: some View {
        Text(stage.label)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

/// One row/card in the topic list: name, subject, unit, revision stage.
struct TopicRow: View {
    let topic: Topic

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(topic.name).font(.headline)
            Text("\(topic.subject) • \(topic.unit)").font(.subheadline).foregroundColor(.secondary)
            StageBadge(stage: topic.stage)
        }
        .padding(.vertical, 4)
    }
}

/// Horizontally scrolling single-select chips. `nil` represents the "All" option.
struct FilterChipsRow<T: Hashable>: View {
    let options: [T?]
    let selected: T?
    let label: (T?) -> String
    let onSelect: (T?) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Button(label(option)) { onSelect(option) }
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(option == selected ? Color.accentColor : Color(.secondarySystemBackground))
                        .foregroundColor(option == selected ? .white : .primary)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
    }
}
