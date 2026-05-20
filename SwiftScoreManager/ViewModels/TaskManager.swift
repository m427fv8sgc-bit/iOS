//
//  TaskManager.swift
//  SwiftScoreManager
//
//  Created by Uttam Bhattcharjee on 04/05/26.
//

import Foundation
import Combine

// MARK: - Sort Option
enum SortOption: String, CaseIterable, Identifiable {
    case nameAscending = "Name A-Z"
    case scoreHighToLow = "Score High-Low"
    case scoreLowToHigh = "Score Low-High"

    var id: String {
        rawValue
    }
}

// MARK: - Filter Option
enum FilterOption: String, CaseIterable, Identifiable {
    case all = "All"
    case passed = "Passed"
    case failed = "Failed"
    case gradeA = "Grade A"
    case gradeB = "Grade B"
    case gradeC = "Grade C"
    case gradeD = "Grade D"
    case gradeF = "Grade F"

    var id: String {
        rawValue
    }
}

// MARK: - Score Manager
class ScoreManager: ObservableObject {
    @Published var students: [Student] = Student.sampleStudents
    @Published var searchText: String = ""
    @Published private(set) var selectedSortOption: SortOption?
    @Published private(set) var selectedFilterOption: FilterOption = .all

    var filteredStudents: [Student] { //This (filteredStudents) is a Computed property not a function...
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return students.filter { student in
            let matchesFilter: Bool

            switch selectedFilterOption {
            case .all:
                matchesFilter = true
            case .passed:
                matchesFilter = student.hasPassed
            case .failed:
                matchesFilter = !student.hasPassed
            case .gradeA:
                matchesFilter = student.grade == .a
            case .gradeB:
                matchesFilter = student.grade == .b
            case .gradeC:
                matchesFilter = student.grade == .c
            case .gradeD:
                matchesFilter = student.grade == .d
            case .gradeF:
                matchesFilter = student.grade == .f
            }

            guard matchesFilter else {
                return false
            }

            guard !trimmedSearchText.isEmpty else {
                return true
            }

            return student.name.localizedCaseInsensitiveContains(trimmedSearchText)
                || student.note?.localizedCaseInsensitiveContains(trimmedSearchText) == true
                || String(student.score).contains(trimmedSearchText)
                || student.grade.rawValue.localizedCaseInsensitiveContains(trimmedSearchText)
        }
    }
    
    func addStudent(name: String, score: Int, note: String?) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            return false
        }
        
        guard score >= 0 && score <= 100 else {
            return false
        }
        
        let trimmedNote = note?.trimmingCharacters(in: .whitespacesAndNewlines)
        let newStudent = Student(
            name: trimmedName,
            score: score,
            note: trimmedNote?.isEmpty == true ? nil : trimmedNote
        )
        
        students.append(newStudent)
        applySelectedSort()
        return true
    }

    func updateStudent(id: UUID, name: String, score: Int, note: String?) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            return false
        }

        guard score >= 0 && score <= 100 else {
            return false
        }

        guard let index = students.firstIndex(where: { $0.id == id }) else {
            return false
        }

        let trimmedNote = note?.trimmingCharacters(in: .whitespacesAndNewlines)
        students[index].name = trimmedName
        students[index].score = score
        students[index].note = trimmedNote?.isEmpty == true ? nil : trimmedNote

        applySelectedSort()
        return true
    }
    
    func deleteStudent(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            students.remove(at: index)
        }
    }

    func deleteFilteredStudent(at offsets: IndexSet) {
        let displayedStudents = filteredStudents
        let idsToDelete = offsets.map { displayedStudents[$0].id }

        students.removeAll { student in
            idsToDelete.contains(student.id)
        }
    }

    func sortStudents(by option: SortOption) {
        selectedSortOption = option
        applySelectedSort()
    }

    func filterStudents(by option: FilterOption) {
        selectedFilterOption = option
    }

    func averageFilteredScore() -> Double {
        averageScore(for: filteredStudents)
    }
    
    func averageScore() -> Double {
        averageScore(for: students)
    }

    private func applySelectedSort() {
        guard let selectedSortOption else {
            return
        }

        switch selectedSortOption {
        case .nameAscending:
            students.sort { firstStudent, secondStudent in
                firstStudent.name < secondStudent.name
            }
        case .scoreHighToLow:
            students.sort { firstStudent, secondStudent in
                firstStudent.score > secondStudent.score
            }
        case .scoreLowToHigh:
            students.sort { firstStudent, secondStudent in
                firstStudent.score < secondStudent.score
            }
        }
    }

    private func averageScore(for students: [Student]) -> Double {
        guard !students.isEmpty else {
            return 0
        }
        
        let totalScore = students.reduce(0) { total, student in
            total + student.score
        }
        
        return Double(totalScore) / Double(students.count)
    }
}
