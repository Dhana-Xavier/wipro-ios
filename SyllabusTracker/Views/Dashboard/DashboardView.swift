import SwiftUI

/// Home screen: preparation overview + navigation entry point.
struct DashboardView: View {
    @StateObject private var vm: DashboardViewModel

    init(repository: TopicRepository) {
        _vm = StateObject(wrappedValue: DashboardViewModel(repository: repository))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(Int(vm.stats.completionFraction * 100))% of syllabus completed")
                        .font(.headline)
                    ProgressView(value: vm.stats.completionFraction)
                }
                .cardStyle()

                HStack(spacing: 12) {
                    StatCard(label: "Total Topics", value: vm.stats.totalTopics)
                    StatCard(label: "Completed", value: vm.stats.completedTopics)
                    StatCard(label: "Pending", value: vm.stats.pendingTopics)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Subject with most pending topics").font(.caption).foregroundColor(.secondary)
                    Text(mostPendingText).font(.headline)
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: 6) {
                    Text("Revision rounds").font(.caption).foregroundColor(.secondary)
                    ForEach(RevisionStage.allCases) { stage in
                        HStack {
                            Text(stage.label)
                            Spacer()
                            Text("\(vm.stats.stageCounts[stage] ?? 0)")
                        }
                    }
                }
                .cardStyle()

                NavigationLink(value: Route.list) {
                    Label("View all topics", systemImage: "list.bullet")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: Route.form(nil)) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private var mostPendingText: String {
        if let subject = vm.stats.subjectWithMostPending {
            return "\(subject) (\(vm.stats.mostPendingCount) pending)"
        }
        return vm.stats.totalTopics == 0 ? "No topics yet — add your first one" : "Everything is completed"
    }
}
