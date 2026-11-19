import SwiftUI

/// Scrollable list of all topics with search and filters.
struct TopicListView: View {
    @StateObject private var vm: TopicListViewModel
    @State private var topicToDelete: Topic?

    init(repository: TopicRepository) {
        _vm = StateObject(wrappedValue: TopicListViewModel(repository: repository))
    }

    private var subjectOptions: [String?] { [nil] + Subjects.all.map { Optional($0) } }
    private var stageOptions: [RevisionStage?] { [nil] + RevisionStage.allCases.map { Optional($0) } }

    var body: some View {
        VStack(spacing: 8) {
            FilterChipsRow(
                options: subjectOptions,
                selected: vm.subjectFilter,
                label: { $0 ?? "All Subjects" },
                onSelect: { vm.subjectFilter = $0 }
            )
            FilterChipsRow(
                options: stageOptions,
                selected: vm.stageFilter,
                label: { $0?.label ?? "All Stages" },
                onSelect: { vm.stageFilter = $0 }
            )

            List(vm.topics) { topic in
                NavigationLink(value: Route.detail(topic.id)) {
                    TopicRow(topic: topic)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        topicToDelete = topic
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .listStyle(.plain)
            .overlay {
                if vm.topics.isEmpty {
                    Text("No topics found").foregroundColor(.secondary)
                }
            }
        }
        .searchable(text: $vm.query, prompt: "Search by topic name")
        .navigationTitle("All Topics")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: Route.form(nil)) {
                    Image(systemName: "plus")
                }
            }
        }
        .confirmationDialog(
            "Delete topic?",
            isPresented: Binding(
                get: { topicToDelete != nil },
                set: { if !$0 { topicToDelete = nil } }
            ),
            titleVisibility: .visible,
            presenting: topicToDelete
        ) { topic in
            Button("Delete \"\(topic.name)\"", role: .destructive) { vm.delete(topic) }
        }
    }
}
