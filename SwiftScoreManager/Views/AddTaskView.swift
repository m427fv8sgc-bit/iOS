//
//  AddTaskView.swift
//  SwiftScoreManager
//
//  Created by Uttam Bhattcharjee on 04/05/26.
//

import SwiftUI

// MARK: - Add Student View
struct AddStudentView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var scoreManager: ScoreManager
    
    @State private var name = ""
    @State private var score = 70
    @State private var note = ""
    @State private var showError = false
    
    var body: some View { // Review: combine add and edit scene both in single component.
        //Also modularise the code for internal types and properties.
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
            .navigationTitle("Add Student")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveStudent()
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
    
    private func saveStudent() {
        let success = scoreManager.addStudent(
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

struct AddStudentView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudentView(scoreManager: ScoreManager())
    }
}
