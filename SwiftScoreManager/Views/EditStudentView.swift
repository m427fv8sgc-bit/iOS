//
//  EditStudentView.swift
//  SwiftScoreManager
//
//  Created by Uttam Bhattcharjee on 04/05/26.
//

import SwiftUI

// MARK: - Edit Student View
struct EditStudentView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var scoreManager: ScoreManager
    let student: Student

    @State private var name: String
    @State private var score: Int
    @State private var note: String
    @State private var showError = false

    init(scoreManager: ScoreManager, student: Student) {
        self.scoreManager = scoreManager
        self.student = student
        //_name = State(initialValue: student.name)
        name =  student.name
        _score = State(initialValue: student.score)
        _note = State(initialValue: student.note ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Student") {
                    TextField("Name", text: $name)

                    Stepper("Score: \(score)", value: $score, in: 0...100)
                }

                Section("Optional Note") {
                    TextField("Note", text: $note)
                }

                Section("Result Preview") {
                    let previewStudent = Student(name: name, score: score, note: note)

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
            .navigationTitle("Edit Student")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
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

    private func saveChanges() {
        let success = scoreManager.updateStudent(
            id: student.id,
            name: name,
            score: score,
            note: note
        )

        if success {
            dismiss()
        } else {
            showError = true
        }
    }
}

struct EditStudentView_Previews: PreviewProvider {
    static var previews: some View {
        EditStudentView(
            scoreManager: ScoreManager(),
            student: Student.sampleStudents[0]
        )
    }
}
