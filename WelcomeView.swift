import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            VStack(alignment: .leading, spacing: Theme.sectionSpacing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Witness")
                        .font(.system(size: 52, weight: .light, design: .serif))
                        .foregroundColor(Theme.primary)
                    Text("Ready")
                        .font(.system(size: 52, weight: .semibold, design: .serif))
                        .foregroundColor(Theme.accent)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.1), value: appeared)

                Rectangle()
                    .fill(Theme.accent)
                    .frame(width: 48, height: 2)
                    .cornerRadius(1)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)

                VStack(alignment: .leading, spacing: 12) {
                    Text("You have something important to do.")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Theme.primary)
                    Text("This experience is here to help you feel calmer, more familiar with what is ahead, and more prepared to give your honest account.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Theme.secondary)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 12)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: appeared)
            }

            Spacer()

            VStack(spacing: 14) {
                Button {
                    appState.navigate(to: .checkIn)
                } label: {
                    Text("Begin")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.accent)
                        .cornerRadius(Theme.buttonRadius)
                }
                .buttonStyle(.plain)

                Text("This app is not legal advice and does not record any case information.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Theme.secondary.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 10)
            .animation(.easeOut(duration: 0.5).delay(0.6), value: appeared)
            .padding(.bottom, 52)
        }
        .padding(.horizontal, Theme.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .onAppear { appeared = true }
    }
}
