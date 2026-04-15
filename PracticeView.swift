import SwiftUI

struct PracticeView: View {
    @EnvironmentObject var appState: AppState
    @State private var deck: [PracticeCard] = []
    @State private var currentIndex = 0
    @State private var cardVisible = false
    @State private var slideFromRight = true
    @State private var appeared = false

    private var current: PracticeCard { deck[currentIndex] }
    private var isFirst: Bool { currentIndex == 0 }
    private var isLast: Bool { deck.isEmpty ? true : currentIndex == deck.count - 1 }
    private var progress: Double { deck.isEmpty ? 0 : Double(currentIndex + 1) / Double(deck.count) }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if appState.hasCompletedGuide && !isLast {
                    Button {
                        appState.selectedPracticeCategory = nil
                        appState.navigate(to: .explorePractice)
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .medium))
                            Text("Back")
                                .font(.system(size: 15, weight: .regular))
                        }
                        .foregroundColor(Theme.accent)
                    }
                    .buttonStyle(.plain)
                } else {
                    Spacer().frame(width: 44)
                }

                Spacer()

                Text(deck.isEmpty ? "" : "\(currentIndex + 1) of \(deck.count)")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Theme.secondary)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 64)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.4).delay(0.1), value: appeared)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Theme.divider).frame(height: 2).cornerRadius(1)
                    Rectangle()
                        .fill(Theme.accent)
                        .frame(width: geo.size.width * progress, height: 2)
                        .cornerRadius(1)
                        .animation(.easeInOut(duration: 0.35), value: progress)
                }
            }
            .frame(height: 2)
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 12)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.4).delay(0.1), value: appeared)

            Spacer()

            if !deck.isEmpty {
                Group {
                    if current.type == .question {
                        QuestionCard(card: current)
                    } else {
                        ReminderCard(card: current)
                    }
                }
                .id(currentIndex)
                .padding(.horizontal, Theme.screenPadding)
                .opacity(cardVisible ? 1 : 0)
                .offset(x: cardVisible ? 0 : (slideFromRight ? 28 : -28))
                .animation(.easeOut(duration: 0.35), value: cardVisible)
            }

            Spacer()

            HStack(spacing: 12) {
                if !isFirst {
                    Button { goBack() } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .medium))
                            Text("Previous")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(Theme.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.accent.opacity(0.08))
                        .cornerRadius(Theme.buttonRadius)
                        .overlay(RoundedRectangle(cornerRadius: Theme.buttonRadius).stroke(Theme.accent.opacity(0.25), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .offset(x: -8)))
                }

                Button {
                    if isLast {
                        if appState.hasCompletedGuide {
                            appState.selectedPracticeCategory = nil
                            appState.navigate(to: .explorePractice)
                        } else {
                            appState.navigate(to: .closing)
                        }
                    } else {
                        goForward()
                    }
                } label: {
                    Text(isLast ? "Complete" : "Next")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.accent)
                        .cornerRadius(Theme.buttonRadius)
                }
                .buttonStyle(.plain)
            }
            .animation(.easeInOut(duration: 0.25), value: isFirst)
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 52)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.4).delay(0.3), value: appeared)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .onAppear {
            if let category = appState.selectedPracticeCategory {
                deck = PracticeCard.buildCategoryDeck(category)
            } else {
                deck = PracticeCard.buildDeck(worries: appState.mainWorries, isFirstTime: appState.isFirstTime)
            }
            appeared = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeOut(duration: 0.4)) { cardVisible = true }
            }
        }
    }

    private func goForward() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        slideFromRight = true
        withAnimation(.easeOut(duration: 0.18)) { cardVisible = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            currentIndex += 1
            withAnimation(.easeOut(duration: 0.35)) { cardVisible = true }
        }
    }

    private func goBack() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        slideFromRight = false
        withAnimation(.easeOut(duration: 0.18)) { cardVisible = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            currentIndex -= 1
            withAnimation(.easeOut(duration: 0.35)) { cardVisible = true }
        }
    }
}

struct QuestionCard: View {
    let card: PracticeCard

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Question")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Theme.accent)
                .textCase(.uppercase)
                .kerning(1.0)
            Rectangle().fill(Theme.divider).frame(height: 1)
            Text(card.content)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundColor(Theme.primary)
                .lineSpacing(7)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 24)
            Text("Take a moment before you answer.")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Theme.secondary)
                .italic()
        }
        .padding(28)
        .frame(maxWidth: .infinity, minHeight: 270, alignment: .leading)
        .background(Theme.surface)
        .cornerRadius(Theme.cardRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cardRadius).stroke(Theme.divider, lineWidth: 1))
        .shadow(color: Theme.cardShadow, radius: 18, x: 0, y: 6)
    }
}

struct ReminderCard: View {
    let card: PracticeCard

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8) {
                Rectangle().fill(Theme.accent).frame(width: 3, height: 16).cornerRadius(2)
                Text("Keep in mind")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.accent)
                    .textCase(.uppercase)
                    .kerning(1.0)
            }
            Text(card.content)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Theme.primary)
                .lineSpacing(7)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(28)
        .frame(maxWidth: .infinity, minHeight: 270, alignment: .leading)
        .background(Theme.accent.opacity(0.07))
        .cornerRadius(Theme.cardRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cardRadius).stroke(Theme.accent.opacity(0.22), lineWidth: 1))
    }
}
