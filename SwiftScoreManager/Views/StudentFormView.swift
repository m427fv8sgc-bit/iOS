//
//  StudentFormView.swift
//  SwiftScoreManager
//
//  Created by Uttam Bhattcharjee on 04/05/26.
//

import SwiftUI

// MARK: - Student Form View
struct StudentFormView: View {
    enum Mode: Identifiable {
        case add
        case edit(Student)

        var id: String {
            switch self {
            case .add:
                return "add"
            case .edit(let student):
                return "edit-\(student.id.uuidString)"
            }
        }

        var title: String {
            switch self {
            case .add:
                return "Add Student"
            case .edit:
                return "Edit Student"
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var scoreManager: ScoreManager
    let mode: Mode

    @State private var name: String
    @State private var score: Int
    @State private var note: String
    @State private var showError = false

    init(scoreManager: ScoreManager, mode: Mode = .add) {
        self.scoreManager = scoreManager
        self.mode = mode

        switch mode {
        case .add:
            _name = State(initialValue: "")
            _score = State(initialValue: 70)
            _note = State(initialValue: "")
        case .edit(let student):
            _name = State(initialValue: student.name)
            _score = State(initialValue: student.score)
            _note = State(initialValue: student.note ?? "")
        }
    }

    var body: some View {
        NavigationView {
            Form {
                studentSection
                noteSection
                previewSection
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                }
            }
            .alert("Invalid Student", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a name and a score from 0 to 100.")
            }
        }
    }

    private var studentSection: some View {
        Section("Student") {
            TextField("Name", text: $name)

            Stepper("Score: \(score)", value: $score, in: 0...100)
        }
    }

    private var noteSection: some View {
        Section("Optional Note") {
            TextField("Note", text: $note)
        }
    }

    private var previewSection: some View {
        Section("Result Preview") {
            HStack {
                Text("Grade")
                Spacer()
                Text(previewStudent.grade.rawValue)
                    .fontWeight(.semibold)
            }

            HStack {
                Text("Status")
                Spacer()
                Text(previewStudent.hasPassed ? "Passed" : "Failed")
                    .foregroundColor(previewStudent.hasPassed ? .green : .red)
            }
        }
    }

    private var previewStudent: Student {
        Student(name: name, score: score, note: note)
    }

    private func save() {
        let success: Bool

        switch mode {
        case .add:
            success = scoreManager.addStudent(
                name: name,
                score: score,
                note: note
            )
        case .edit(let student):
            success = scoreManager.updateStudent(
                id: student.id,
                name: name,
                score: score,
                note: note
            )
        }
        
        if success {
            dismiss()
        } else {
            showError = true
        }
    }
}

struct StudentFormView_Previews: PreviewProvider {
    static var previews: some View {
        StudentFormView(scoreManager: ScoreManager())
        StudentFormView(
            scoreManager: ScoreManager(),
            mode: .edit(Student.sampleStudents[0])
        )
    }
}
