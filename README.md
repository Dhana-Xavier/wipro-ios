# Exam Syllabus Tracker (Project 20) — iOS / SwiftUI (MVVM)

Requires a Mac with Xcode 15+. Deployment target iOS 16. iPhone, portrait only.

## Create the Xcode project (pick one)
**A. Manual (no extra tools)**
1. Xcode > File > New > Project > iOS App. Name `SyllabusTracker`, Interface: SwiftUI, Language: Swift.
2. Delete the generated `ContentView.swift` and `SyllabusTrackerApp.swift`.
3. Drag the contents of this folder's `SyllabusTracker/` (all folders + `SyllabusTrackerApp.swift`) into the project, "Copy items if needed" + "Create groups". When asked about `Assets.xcassets`, replace the existing one (keeps the app icon).
4. Target > Info tab: add `Privacy - Face ID Usage Description` = "Face ID is used to unlock your syllabus tracker."
5. Target > General: iPhone only, Portrait only.

**B. XcodeGen:** `brew install xcodegen && xcodegen` in this folder, then open the generated `.xcodeproj`.

## Login
Face ID prompt shows at launch. If unavailable/cancelled/failed, manual login appears.
Demo credentials: `student` / `exam123`.
Simulator: Features > Face ID > Enrolled, then Matching Face.

## Architecture
- `Models/`     Topic, enums, DashboardStats (pure logic)
- `Services/`   TopicRepository (JSON persistence, single source of truth), BiometricService, CredentialValidator  <- the Swift "backend"
- `ViewModels/` one ViewModel per feature
- `Views/`      one folder per feature + shared Components;  `Navigation/Route.swift` + `Views/RootView.swift` for navigation
