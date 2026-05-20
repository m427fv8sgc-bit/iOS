# SwiftScoreManager

A beginner-friendly SwiftUI app for practicing Swift fundamentals.

This version is intentionally small. It shows a list of students, lets you add a new student, calculates each student's grade, shows pass/fail status, and displays the class average.

## What The App Does

- Shows sample students
- Adds a student with name, score, and optional note
- Deletes students from the list
- Calculates grade from score
- Shows pass/fail status
- Shows average score

## Files To Study

```text
SwiftScoreManager/
├── Models/
│   └── Task.swift              # Student model and Grade enum
├── ViewModels/
│   └── TaskManager.swift       # ScoreManager class and app logic
├── Views/
│   ├── ContentView.swift       # Main list screen
│   └── AddTaskView.swift       # Add student form
└── SwiftScoreManagerApp.swift   # App entry point
```

The code is organized as a small student-score app for practicing Swift fundamentals.

## Swift Concepts Covered

- `let` and `var`
- `String`, `Int`, `Double`, `Bool`
- Optionals with `String?`
- Arrays with `[Student]`
- Enum with `Grade`
- Struct with `Student`
- Class with `ScoreManager`
- Computed properties
- Functions
- `guard`
- `if let`
- `switch`
- Ranges like `90...100`
- Closures with `reduce`
- SwiftUI basics: `NavigationView`, `List`, `Form`, `TextField`, `Stepper`, `Button`, `Sheet`
- Property wrappers: `@State`, `@StateObject`, `@ObservedObject`, `@Published`, `@Environment`

## Best Learning Order

1. [Task.swift](SwiftScoreManager/Models/Task.swift)
2. [TaskManager.swift](SwiftScoreManager/ViewModels/TaskManager.swift)
3. [AddTaskView.swift](SwiftScoreManager/Views/AddTaskView.swift)
4. [ContentView.swift](SwiftScoreManager/Views/ContentView.swift)

## How To Run

Open `SwiftScoreManager.xcodeproj` in Xcode and run the `SwiftScoreManager` scheme. The app display name is **SwiftScoreManager**.

## Next Features To Add Later

- Edit a student
- Search students
- Sort by score
- Filter by grade
- Save data with `UserDefaults`
# iOS
