import SwiftUI

private enum CalmBreathPhase {
    case rest, inhale, hold, exhale

    var label: String {
        switch self {
        case .rest:
            return ""
        case .inhale:
            return "Breathe in"
        case .hold:
            return "Hold"
        case .exhale:
            return "Breathe out"
        }
    }

    var duration: Double {
        switch self {
        case .rest:
            return 0
        case .inhale:
            return 4.0
        case .hold:
            return 2.0
        case .exhale:
            return 6.0
        }
    }

    var scale: CGFloat {
        switch self {
        case .rest, .exhale:
            return 0.55
        case .inhale, .hold:
            return 1.0
        }
    }
}

struct CalmView: View {
    @EnvironmentObject var appState: AppState
    @State private var appeared = false
    @State private var phase: CalmBreathPhase = .rest
    @State private var circleScale: CGFloat = 0.55
    @State private var cycles = 0
    @State private var animating = false
    @State private var showDone = false
    private let targetCycles = 3

    private var subtitle: String {
        switch appState.nervousness {
        case .veryNervous:
            return "You mentioned feeling very nervous. That is completely okay. Let us slow down together."
        case .somewhat:
            return "Feeling nervous is natural. Let us take a few breaths to help you settle."
        case .aLittle:
            return "Even a little nervousness is worth addressing. Let us take a quiet moment."
        case .mostlyCalm:
            return "It is good that you are feeling calm. A few slow breaths before court is always good practice."
        case nil:
            return "Three slow breaths before we continue."
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 10) {
                Text("Take a moment")
                    .font(.system(size: 30, weight: .semibold, design: .serif))
                    .foregroundColor(Theme.primary)
                Text(subtitle)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Theme.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, Theme.screenPadding)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
            .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

            Spacer()

            ZStack {
                Circle().fill(Theme.accent.opacity(0.07)).frame(width: 240, height: 240)
                Circle().fill(Theme.accent.opacity(0.13)).frame(width: 190, height: 190).scaleEffect(circleScale)
                Circle().fill(Theme.accent.opacity(0.28)).frame(width: 120, height: 120).scaleEffect(circleScale)
            }
            .frame(width: 240, height: 240)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.25), value: appeared)

            Text(phase == .rest ? "Begin when you are ready" : phase.label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.accentDeep)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
                .animation(nil, value: phase.label)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)

            Spacer()

            HStack(spacing: 10) {
                ForEach(0..<targetCycles, id: \.self) { i in
                    Circle()
                        .fill(i < cycles ? Theme.accent : Theme.divider)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: cycles)
                }
            }
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.35), value: appeared)

            Spacer()

            VStack(spacing: 14) {
                if showDone {
                    Text("Well done.")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Theme.calmGreen)
                        .transition(.opacity)

                    Button {
                        appState.navigate(to: .expectations)
                    } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.accent)
                            .cornerRadius(Theme.buttonRadius)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .offset(y: 8)))
                } else if !animating {
                    Button { startBreathing() } label: {
                        Text("Start")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.accent)
                            .cornerRadius(Theme.buttonRadius)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity)
                } else {
                    Color.clear.frame(height: 52)
                }
            }
            .frame(minHeight: 90)
            .padding(.bottom, 52)
            .padding(.horizontal, Theme.screenPadding)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.4), value: appeared)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .onAppear { appeared = true }
    }

    private func startBreathing() {
        animating = true
        runCycle()
    }

    private func runCycle() {
        runPhase(.inhale) {
            runPhase(.hold) {
                runPhase(.exhale) {
                    withAnimation(.easeInOut(duration: 0.3)) { cycles += 1 }
                    if cycles < targetCycles {
                        runCycle()
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showDone = true
                            animating = false
                            phase = .rest
                            circleScale = CalmBreathPhase.rest.scale
                        }
                    }
                }
            }
        }
    }

    private func runPhase(_ next: CalmBreathPhase, completion: @escaping () -> Void) {
        withAnimation(.none) { phase = next }
        let duration = (next == .inhale || next == .exhale) ? next.duration : 0.3
        withAnimation(.easeInOut(duration: duration)) { circleScale = next.scale }
        DispatchQueue.main.asyncAfter(deadline: .now() + next.duration) { completion() }
    }
}
