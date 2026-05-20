//
//  Task.swift
//  SwiftScoreManager
//
//  Created by Uttam Bhattcharjee on 04/05/26.
//

import Foundation

// MARK: - Grade
enum Grade: String, CaseIterable {
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case f = "F"
}

// MARK: - Student
struct Student: Identifiable {
    let id = UUID()
    var name: String
    var score: Int
    var note: String?
    
    var grade: Grade {
        switch score {
        case 90...100:
            return .a
        case 75..<90:
            return .b
        case 60..<75:
            return .c
        case 40..<60:
            return .d
        default:
            return .f
        }
    }
    
    var hasPassed: Bool {
        score >= 40
    }
}

extension Student {
    static let sampleStudents = [
        Student(name: "Anika Sharma", score: 92, note: "Strong in problem solving"),
        Student(name: "Rahul Mehta", score: 78, note: "Good improvement"),
        Student(name: "Maya Sen", score: 64, note: nil)
    ]
}

