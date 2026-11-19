import SwiftUI

/// Add / Edit topic form. Pops itself after a successful save.
struct TopicFormView: View {
    @StateObject private var vm: TopicFormViewModel
    @Environment(\.dismiss) private var dismiss

    init(repository: TopicRepository, topicID: UUID?) {
        _vm = StateObject(wrappedValue: TopicFormViewModel(repository: repository, topicID: topicID))
    }

    var body: some View {
        Form {
            Section("Topic") {
                TextField("Topic name", text: $vm.name)
                errorText(vm.nameError)
                Picker("Subject", selection: $vm.subject) {
                    ForEach(Subjects.all, id: \.self) { Text($0).tag($0) }
                }
                TextField("Unit (e.g. Unit 2)", text: $vm.unit)
                errorText(vm.unitError)
            }

            Section("Importance") {
                Picker("Importance", selection: $vm.importance) {
                    ForEach(Importance.allCases) { Text($0.label).tag($0) }
                }
                .pickerStyle(.segmented)
            }

            if vm.isEditing {
                Section("Revision stage (can only move forward)") {
                    Picker("Stage", selection: $vm.stage) {
                        ForEach(vm.availableStages) { Text($0.label).tag($0) }
                    }
                }
            }

            Section("Notes / formulas") {
                TextField("Notes", text: $vm.notes, axis: .vertical)
                    .lineLimit(3...8)
            }

            Section {
                Button(vm.isEditing ? "Save changes" : "Add topic") {
                    if vm.save() { dismiss() }
                }
            }
        }
        .navigationTitle(vm.isEditing ? "Edit Topic" : "Add Topic")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func errorText(_ message: String?) -> some View {
        if let message {
            Text(message).font(.caption).foregroundColor(.red)
        }
    }
}
