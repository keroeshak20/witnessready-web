import SwiftUI

private struct CourtroomItem: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

private let courtroomItems: [CourtroomItem] = [
    CourtroomItem(title: "The setting", body: "A courtroom is a formal and often quiet space. It may feel more serious than you expect. That formality is intentional. It gives weight to what is said. You belong there as a witness."),
    CourtroomItem(title: "Who will be there", body: "You will see a judge, attorneys from both sides, and possibly a jury. Everyone in the room has a specific role. Your role is simply to answer the questions asked of you."),
    CourtroomItem(title: "How questions work", body: "You will be asked questions by one attorney, then possibly by the other. Questions will be direct. Answer what is asked, then stop. You do not need to give long explanations unless asked."),
    CourtroomItem(title: "What you are allowed to do", body: "You may ask for a question to be repeated. You may say you do not know or do not recall. You may take a moment before answering. None of these are signs of weakness."),
    CourtroomItem(title: "What you are there to do", body: "You are there to share what you honestly know. Not to convince anyone. Not to win or lose. Just to tell what you observed, clearly and truthfully.")
]

private let supportReminders: [String] = [
    "Pause before answering. There is no rush.",
    "Ask for a question to be repeated if you need to.",
    "Do not guess. \"I do not recall\" is a complete and honest answer.",
    "Answer only what was asked. Stop when the answer is complete.",
    "Speak in your own words, slowly and clearly.",
    "You are there to tell what you know. Nothing more."
]

struct ExploreCourtroomView: View {
    @EnvironmentObject var appState: AppState
    @State private var headerAppeared = false
    @State private var cardCount = 0
    @State private var remindersHeader = false
    @State private var reminderCount = 0

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Theme.sectionSpacing) {
                VStack(alignment: .leading, spacing: 20) {
                    Button { appState.goHome() } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left").font(.system(size: 14, weight: .medium))
                            Text("Back").font(.system(size: 15, weight: .regular))
                        }
                        .foregroundColor(Theme.accent)
                    }
                    .buttonStyle(.plain)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Courtroom").font(.system(size: 28, weight: .semibold, design: .serif)).foregroundColor(Theme.primary)
                        Text("What to expect and the reminders that matter most.").font(.system(size: 15, weight: .regular)).foregroundColor(Theme.secondary).lineSpacing(4).fixedSize(horizontal: false, vertical: true)
                    }
                }
                .opacity(headerAppeared ? 1 : 0)
                .offset(y: headerAppeared ? 0 : 14)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: headerAppeared)

                Text("What to expect")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.accent)
                    .textCase(.uppercase)
                    .kerning(0.9)
                    .opacity(headerAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.2), value: headerAppeared)

                VStack(spacing: 12) {
                    ForEach(Array(courtroomItems.enumerated()), id: \.element.id) { index, item in
                        if index < cardCount {
                            CourtroomItemCard(item: item)
                                .transition(.asymmetric(insertion: .opacity.combined(with: .offset(y: 14)), removal: .opacity))
                        }
                    }
                }

                if remindersHeader {
                    VStack(alignment: .leading, spacing: 16) {
                        Rectangle().fill(Theme.divider).frame(height: 1)
                        Text("Support reminders")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Theme.accent)
                            .textCase(.uppercase)
                            .kerning(0.9)

                        VStack(spacing: 0) {
                            ForEach(Array(supportReminders.enumerated()), id: \.offset) { index, reminder in
                                if index < reminderCount {
                                    ReminderRowItem(text: reminder)
                                        .transition(.asymmetric(insertion: .opacity.combined(with: .offset(y: 10)), removal: .opacity))
                                    if index < supportReminders.count - 1 {
                                        Rectangle().fill(Theme.divider).frame(height: 1).padding(.vertical, 2)
                                    }
                                }
                            }
                        }
                        .background(Theme.surface)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.divider, lineWidth: 1))
                    }
                    .transition(.opacity.combined(with: .offset(y: 10)))
                }

                Spacer(minLength: 52)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 64)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) { headerAppeared = true }
            for i in 0..<courtroomItems.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35 + Double(i) * 0.2) {
                    withAnimation(.easeOut(duration: 0.4)) { cardCount = i + 1 }
                }
            }
            let remindersStart = 0.35 + Double(courtroomItems.count) * 0.2 + 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + remindersStart) {
                withAnimation(.easeOut(duration: 0.4)) { remindersHeader = true }
            }
            for i in 0..<supportReminders.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + remindersStart + 0.2 + Double(i) * 0.15) {
                    withAnimation(.easeOut(duration: 0.35)) { reminderCount = i + 1 }
                }
            }
        }
    }
}

private struct CourtroomItemCard: View {
    let item: CourtroomItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title).font(.system(size: 11, weight: .semibold)).foregroundColor(Theme.accent).textCase(.uppercase).kerning(0.9)
            Text(item.body).font(.system(size: 15, weight: .regular)).foregroundColor(Theme.primary).lineSpacing(5).fixedSize(horizontal: false, vertical: true)
        }
        .padding(Theme.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.divider, lineWidth: 1))
    }
}

private struct ReminderRowItem: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Rectangle().fill(Theme.accent).frame(width: 2, height: 16).cornerRadius(1).padding(.top, 2)
            Text(text).font(.system(size: 15, weight: .regular)).foregroundColor(Theme.primary).lineSpacing(4).fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(.horizontal, Theme.cardPadding)
        .padding(.vertical, 14)
    }
}
