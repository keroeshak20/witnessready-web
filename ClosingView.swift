import SwiftUI

struct ClosingView: View {
    @EnvironmentObject var appState: AppState
    @State private var appeared = false

    private let reminders: [String] = [
        "Answer honestly from what you know.",
        "Pause when you need to.",
        "Ask for a question to be repeated if you need to.",
        "You do not have to remember everything perfectly.",
        "Speak clearly and at your own pace."
    ]

    private var closingSubtitle: String {
        if appState.isFirstTime == true && appState.nervousness == .veryNervous {
            return "Coming in as a first-time witness feeling very nervous and working through it anyway says a lot. You are more prepared to answer honestly and clearly than you were when you started."
        } else if appState.isFirstTime == true {
            return "For a first-time witness, taking this time to slow down and prepare is exactly the right step. You are in a better place to answer truthfully and calmly."
        } else if appState.nervousness == .veryNervous {
            return "You came in feeling very nervous and worked through every step. You are calmer now and better prepared to answer each question honestly."
        } else {
            return "Taking time to breathe, understand the setting, and practice is exactly what prepares a witness to answer honestly and clearly. You did that."
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Theme.sectionSpacing) {
                Rectangle()
                    .fill(Theme.accent)
                    .frame(width: 44, height: 3)
                    .cornerRadius(2)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

                VStack(alignment: .leading, spacing: 12) {
                    Text("You took the time to prepare.")
                        .font(.system(size: 36, weight: .semibold, design: .serif))
                        .foregroundColor(Theme.primary)
                    Text(closingSubtitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Theme.secondary)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 14)
                .animation(.easeOut(duration: 0.5).delay(0.2), value: appeared)

                Rectangle().fill(Theme.divider).frame(height: 1)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.35), value: appeared)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Remember")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Theme.accent)
                        .textCase(.uppercase)
                        .kerning(0.9)
                        .padding(.bottom, 6)

                    ForEach(Array(reminders.enumerated()), id: \.offset) { index, reminder in
                        HStack(alignment: .top, spacing: 14) {
                            Circle().fill(Theme.accent.opacity(0.5)).frame(width: 6, height: 6).padding(.top, 7)
                            Text(reminder)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Theme.primary)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 8)
                        .animation(.easeOut(duration: 0.4).delay(0.4 + Double(index) * 0.07), value: appeared)
                    }
                }

                Rectangle().fill(Theme.divider).frame(height: 1)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.75), value: appeared)

                Text("You have done everything you can to prepare. What you know is enough.")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Theme.accent)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.8), value: appeared)

                Button {
                    appState.hasCompletedGuide = true
                    appState.goHome()
                } label: {
                    Text("Explore and Revisit")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.accent)
                        .cornerRadius(Theme.buttonRadius)
                }
                .buttonStyle(.plain)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.9), value: appeared)

                Spacer(minLength: 52)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 72)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .onAppear { appeared = true }
    }
}
