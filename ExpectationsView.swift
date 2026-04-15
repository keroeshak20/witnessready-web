import SwiftUI

private struct ExpectationItem: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

private let items: [ExpectationItem] = [
    ExpectationItem(title: "The setting", body: "A courtroom is a formal and often quiet space. It may feel more serious than you expect. That formality is intentional. It gives weight to what is said. You belong there as a witness."),
    ExpectationItem(title: "Who will be there", body: "You will see a judge, attorneys from both sides, and possibly a jury. Everyone in the room has a specific role. Your role is simply to answer the questions asked of you."),
    ExpectationItem(title: "How questions work", body: "You will be asked questions by one attorney, then possibly by the other. Questions will be direct. Answer what is asked, then stop. You do not need to give long explanations unless asked."),
    ExpectationItem(title: "What you are allowed to do", body: "You may ask for a question to be repeated. You may say you do not know or do not recall. You may take a moment before answering. None of these are signs of weakness."),
    ExpectationItem(title: "What you are there to do", body: "You are there to share what you honestly know. Not to convince anyone. Not to win or lose. Just to tell what you observed, clearly and truthfully.")
]

struct ExpectationsView: View {
    @EnvironmentObject var appState: AppState
    @State private var headerAppeared = false
    @State private var visibleCount = 0
    @State private var footerAppeared = false

    private var subtitle: String {
        if appState.isFirstTime == true {
            return "Since this is your first time, take a moment with each section. Nothing here should surprise you when you walk in."
        } else if appState.isFirstTime == false {
            return "Even with prior experience, a quick reminder of what to expect can help you stay grounded."
        } else {
            return "A short overview so nothing feels unfamiliar when you walk in."
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Theme.sectionSpacing) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("What to expect")
                        .font(.system(size: 30, weight: .semibold, design: .serif))
                        .foregroundColor(Theme.primary)
                    Text(subtitle)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Theme.secondary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .opacity(headerAppeared ? 1 : 0)
                .offset(y: headerAppeared ? 0 : 16)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: headerAppeared)

                VStack(spacing: 12) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        if index < visibleCount {
                            ExpectationCard(item: item)
                                .transition(.asymmetric(insertion: .opacity.combined(with: .offset(y: 16)), removal: .opacity))
                        }
                    }
                }

                if footerAppeared {
                    VStack(alignment: .leading, spacing: Theme.elementSpacing) {
                        HStack(spacing: 10) {
                            Rectangle().fill(Theme.accent).frame(width: 3, height: 36).cornerRadius(2)
                            Text("If anything surprises you in the moment, return to what you know is true and answer from there.")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Theme.secondary)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Button {
                            appState.navigate(to: .practice)
                        } label: {
                            Text("Begin Practice")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Theme.accent)
                                .cornerRadius(Theme.buttonRadius)
                        }
                        .buttonStyle(.plain)
                    }
                    .transition(.asymmetric(insertion: .opacity.combined(with: .offset(y: 12)), removal: .opacity))
                }

                Spacer(minLength: 52)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 64)
        }
        .background(Theme.background.ignoresSafeArea())
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) { headerAppeared = true }
            for i in 0..<items.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35 + Double(i) * 0.2) {
                    withAnimation(.easeOut(duration: 0.4)) { visibleCount = i + 1 }
                }
            }
            let footerDelay = 0.35 + Double(items.count) * 0.2 + 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + footerDelay) {
                withAnimation(.easeOut(duration: 0.4)) { footerAppeared = true }
            }
        }
    }
}

private struct ExpectationCard: View {
    let item: ExpectationItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Theme.accent)
                .textCase(.uppercase)
                .kerning(0.9)
            Text(item.body)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Theme.primary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Theme.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.divider, lineWidth: 1))
    }
}
