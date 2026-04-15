import SwiftUI

private struct HomeSection: Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let screen: AppScreen
}

private let sections: [HomeSection] = [
    HomeSection(title: "Practice", description: "Return to witness questions and choose the type of practice you need.", screen: .explorePractice),
    HomeSection(title: "Calm", description: "Breathing and grounding techniques to help you settle before court.", screen: .exploreCalm),
    HomeSection(title: "Courtroom", description: "What to expect in the courtroom and key reminders to keep in mind.", screen: .exploreCourtroom)
]

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Theme.accent)
                .frame(height: 2)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4), value: appeared)

            VStack(alignment: .leading, spacing: 8) {
                Text("WitnessReady")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.accent)
                    .textCase(.uppercase)
                    .kerning(0.8)
                Text("Return to what helps you most.")
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundColor(Theme.primary)
                    .lineSpacing(4)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 40)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 14)
            .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

            Rectangle().fill(Theme.divider).frame(height: 1)
                .padding(.top, 28)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.25), value: appeared)

            VStack(spacing: 0) {
                ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                    HomeSectionRow(section: section) {
                        appState.navigate(to: section.screen)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeOut(duration: 0.4).delay(0.3 + Double(index) * 0.1), value: appeared)

                    if index < sections.count - 1 {
                        Rectangle().fill(Theme.divider).frame(height: 1)
                            .padding(.horizontal, Theme.screenPadding)
                            .opacity(appeared ? 1 : 0)
                            .animation(.easeOut(duration: 0.4).delay(0.35), value: appeared)
                    }
                }
            }

            Rectangle().fill(Theme.divider).frame(height: 1)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.6), value: appeared)

            Spacer()

            Text("Nothing you do in this app is stored or shared.")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Theme.secondary.opacity(0.55))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.bottom, 40)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.65), value: appeared)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .onAppear { appeared = true }
    }
}

private struct HomeSectionRow: View {
    let section: HomeSection
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(section.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Theme.primary)
                    Text(section.description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Theme.secondary)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.accent)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.vertical, 20)
        }
        .buttonStyle(.plain)
    }
}
