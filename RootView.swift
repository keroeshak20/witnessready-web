import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            switch appState.currentScreen {
            case .welcome:
                WelcomeView()
                    .transition(.opacity)
            case .checkIn:
                CheckInView()
                    .transition(forwardTransition)
            case .calm:
                CalmView()
                    .transition(forwardTransition)
            case .expectations:
                ExpectationsView()
                    .transition(forwardTransition)
            case .practice:
                PracticeView()
                    .transition(forwardTransition)
            case .closing:
                ClosingView()
                    .transition(forwardTransition)
            case .home:
                HomeView()
                    .transition(forwardTransition)
            case .explorePractice:
                ExplorePracticeView()
                    .transition(forwardTransition)
            case .exploreCalm:
                ExploreCalmView()
                    .transition(forwardTransition)
            case .exploreCourtroom:
                ExploreCourtroomView()
                    .transition(forwardTransition)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appState.currentScreen)
    }

    private var forwardTransition: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .offset(y: 20)),
            removal: .opacity
        )
    }
}
