import SwiftUI

struct ExplorePracticeView: View {
    @EnvironmentObject var appState: AppState
    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button { appState.goHome() } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left").font(.system(size: 14, weight: .medium))
                        Text("Back").font(.system(size: 15, weight: .regular))
                    }
                    .foregroundColor(Theme.accent)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 64)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.4).delay(0.05), value: appeared)

            VStack(alignment: .leading, spacing: 8) {
                Text("Practice")
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundColor(Theme.primary)
                Text("Choose the type of session that feels most useful right now.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Theme.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 20)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 14)
            .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

            Rectangle().fill(Theme.divider).frame(height: 1)
                .padding(.top, 24)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.2), value: appeared)

            VStack(spacing: 0) {
                ForEach(Array(PracticeCategory.allCases.enumerated()), id: \.element) { index, category in
                    CategoryRow(category: category) {
                        appState.selectedPracticeCategory = category
                        appState.navigate(to: .practice)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeOut(duration: 0.4).delay(0.25 + Double(index) * 0.08), value: appeared)

                    if index < PracticeCategory.allCases.count - 1 {
                        Rectangle().fill(Theme.divider).frame(height: 1)
                            .padding(.horizontal, Theme.screenPadding)
                    }
                }
            }

            Rectangle().fill(Theme.divider).frame(height: 1)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.65), value: appeared)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .onAppear { appeared = true }
    }
}

private struct CategoryRow: View {
    let category: PracticeCategory
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(category.rawValue)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Theme.primary)
                    Text(category.description)
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
            .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
    }
}
