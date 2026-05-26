//
//  ContentView.swift
//  SwiftScoreManager
//
//  Created by Uttam Bhattcharjee on 04/05/26.
//

import SwiftUI

// MARK: - Content View
struct ContentView: View {
    @StateObject private var scoreManager = ScoreManager()
    @State private var showingComingSoonAlert = false
    @State private var studentFormMode: StudentFormView.Mode?
    
    var body: some View {
        NavigationView {
            VStack {
                sortControlsView
                searchView
                studentsContentView
                averageView
                comingSoonFeaturesView
            }
            .navigationTitle("Score Manager")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        studentFormMode = .add
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            
            }
            .sheet(item: $studentFormMode) { mode in
                StudentFormView(scoreManager: scoreManager, mode: mode)
            }
            .alert("Coming Soon", isPresented: $showingComingSoonAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Will implement next")
            }
        }
    }

    @ViewBuilder
    private var studentsContentView: some View {
        List {
            ForEach(scoreManager.filteredStudents) { student in
                StudentRowView(student: student)
                    .contentShape(Rectangle())
                    .onTapGesture {
                       // studentFormMode = .edit(student)
                        editStudent(student)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                           // studentFormMode = .edit(student)
                            editStudent(student)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
            .onDelete { offsets in
                scoreManager.deleteFilteredStudent(at: offsets)
            }
        }
        .overlay {
            if scoreManager.filteredStudents.isEmpty {
                ContentUnavailableView {
                    Label("No Students Found", systemImage: "magnifyingglass")
                } description: {
                    Text("Try changing your search or filter.")
                }
            }
        }
        
    }
    
    private func editStudent(_ student: Student) { // common function created.
        studentFormMode = .edit(student)
    }
    
    private var averageView: some View {
        HStack {
            Text("Average Score")
            Spacer()
            Text(String(format: "%.1f", scoreManager.averageFilteredScore()))
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }

    private var sortControlsView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if let selectedSortOption = scoreManager.selectedSortOption {
                    Text("Sorted: \(selectedSortOption.rawValue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Sort students")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text("Filter: \(scoreManager.selectedFilterOption.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack {
                SortMenuButton(scoreManager: scoreManager)
                FilterMenuButton(scoreManager: scoreManager)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var searchView: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField("Search scores", text: $scoreManager.searchText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

            if !scoreManager.searchText.isEmpty {
                Button {
                    scoreManager.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.top, 4)
    }

    private var comingSoonFeaturesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Coming Next").font(.headline)
            HStack(spacing: 12) {
                ComingSoonButton(title: "Export", systemImage: "square.and.arrow.up") {
                    showingComingSoonAlert = true
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }
}

// MARK: - Sort Menu Button
struct SortMenuButton: View {
    @ObservedObject var scoreManager: ScoreManager

    var body: some View {
        Menu {
            ForEach(SortOption.allCases) { option in
                Button(option.rawValue) {
                    scoreManager.sortStudents(by: option)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
                .font(.caption)
                .fontWeight(.medium)
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - Filter Menu Button
struct FilterMenuButton: View {
    @ObservedObject var scoreManager: ScoreManager

    var body: some View {
        Menu {
            ForEach(FilterOption.allCases) { option in
                Button(option.rawValue) {
                    scoreManager.filterStudents(by: option)
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .font(.caption)
                .fontWeight(.medium)
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - Coming Soon Button
struct ComingSoonButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.title3)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - Student Row View
struct StudentRowView: View {
    let student: Student
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(student.name)
                    .font(.headline)
                
                if let note = student.note {
                    Text(note)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(student.score)")
                    .font(.headline)
                
                Text("Grade \(student.grade.rawValue)")
                    .font(.caption)
                
                Text(student.hasPassed ? "Passed" : "Failed")
                    .font(.caption)
                    .foregroundColor(student.hasPassed ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
