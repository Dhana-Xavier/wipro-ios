import SwiftUI

/// Full information about one topic, with quick revision-stage progression.
struct TopicDetailView: View {
    @StateObject private var vm: TopicDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteDialog = false

    init(repository: TopicRepository, topicID: UUID) {
        _vm = StateObject(wrappedValue: TopicDetailViewModel(repository: repository, topicID: topicID))
    }

    var body: some View {
        Group {
            if let topic = vm.topic {
                content(for: topic)
            } else {
                Color.clear
            }
        }
        .navigationTitle("Topic Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if let topic = vm.topic {
                    NavigationLink(value: Route.form(topic.id)) {
                        Image(systemName: "pencil")
                    }
                    Button(role: .destructive) {
                        showDeleteDialog = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .confirmationDialog("Delete topic?", isPresented: $showDeleteDialog, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                vm.delete()
                dismiss()
            }
        } message: {
            Text("This topic will be removed from your preparation plan.")
        }
    }

    private func content(for topic: Topic) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(topic.name).font(.title2.bold())

                VStack(alignment: .leading, spacing: 10) {
                    LabeledContent("Subject", value: topic.subject)
                    LabeledContent("Unit", value: topic.unit)
                    LabeledContent("Importance", value: topic.importance.label)
                    HStack {
                        Text("Revision stage")
                        Spacer()
                        StageBadge(stage: topic.stage)
                    }
                    ProgressView(value: Double(topic.stage.rawValue), total: Double(RevisionStage.allCases.count - 1))
                }
                .cardStyle()

                if let next = topic.stage.next {
                    Button {
                        vm.advanceStage()
                    } label: {
                        Text("Move to \(next.label)").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("All revision rounds completed").font(.headline)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Notes / formulas").font(.caption).foregroundColor(.secondary)
                    Text(topic.notes.isEmpty ? "No notes added." : topic.notes)
                }
                .cardStyle()
            }
            .padding()
        }
    }
}
