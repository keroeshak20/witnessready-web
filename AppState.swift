import SwiftUI

enum AppScreen: Equatable {
    case welcome
    case checkIn
    case calm
    case expectations
    case practice
    case closing
    case home
    case explorePractice
    case exploreCalm
    case exploreCourtroom
}

enum NervousnessLevel: String, CaseIterable {
    case veryNervous = "Very nervous"
    case somewhat = "Somewhat nervous"
    case aLittle = "A little bit"
    case mostlyCalm = "Mostly calm"
}

enum MainWorry: String, CaseIterable, Hashable {
    case forgetting = "Forgetting something important"
    case freezing = "Freezing up or going blank"
    case beingJudged = "Being judged or not believed"
    case unknowing = "Not knowing what to expect"
    case sayingWrong = "Saying something wrong"
}

final class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .welcome
    @Published var hasCompletedGuide: Bool = false
    @Published var isFirstTime: Bool? = nil
    @Published var nervousness: NervousnessLevel? = nil
    @Published var mainWorries: Set<MainWorry> = []
    @Published var selectedPracticeCategory: PracticeCategory? = nil

    func navigate(to screen: AppScreen) {
        withAnimation(.easeInOut(duration: 0.4)) {
            currentScreen = screen
        }
    }

    func goHome() {
        withAnimation(.easeInOut(duration: 0.4)) {
            currentScreen = .home
        }
    }

    func restartGuide() {
        withAnimation(.easeInOut(duration: 0.4)) {
            isFirstTime = nil
            nervousness = nil
            mainWorries = []
            selectedPracticeCategory = nil
            currentScreen = .welcome
        }
    }
}
