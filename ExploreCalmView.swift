import SwiftUI

private enum CalmMode {
    case picker
    case breathing
    case grounding
}

private enum ExploreBreathPhase {
    case rest, inhale, hold, exhale

    var label: String {
        switch self {
        case .rest:
            return "Begin when you are ready"
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

private let groundingSteps: [String] = [
    "Look around you. Find three things you can clearly see right now.",
    "Notice the surface beneath you. Feel the weight of your body against it.",
    "Take one slow breath in through your nose. Let it out slowly through your mouth.",
    "Name one thing you know to be true and certain right now.",
    "You are here. You have prepared. That is enough."
]

struct ExploreCalmView: View {
    @EnvironmentObject var appState: AppState
    @State private var mode: CalmMode = .picker
    @State private var appeared = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            switch mode {
            case .picker:
                pickerView.transition(.opacity)
            case .breathing:
                BreathingSessionView(onDone: {
                    withAnimation(.easeInOut(duration: 0.35)) { mode = .picker }
                })
                .transition(.asymmetric(insertion: .opacity.combined(with: .offset(y: 20)), removal: .opacity))
            case .grounding:
                GroundingSessionView(onDone: {
                    withAnimation(.easeInOut(duration: 0.35)) { mode = .picker }
                })
                .transition(.asymmetric(insertion: .opacity.combined(with: .offset(y: 20)), removal: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: mode)
        .onAppear { appeared = true }
    }

    private var pickerView: some View {
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
                Text("Calm")
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundColor(Theme.primary)
                Text("Choose a technique to help you settle before court.")
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
                CalmOptionRow(title: "Breathing", description: "A short guided breathing exercise to slow down and settle.") {
                    withAnimation(.easeInOut(duration: 0.35)) { mode = .breathing }
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .animation(.easeOut(duration: 0.4).delay(0.28), value: appeared)

                Rectangle().fill(Theme.divider).frame(height: 1)
                    .padding(.horizontal, Theme.screenPadding)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.32), value: appeared)

                CalmOptionRow(title: "Grounding", description: "A brief moment to get present and steady before you go in.") {
                    withAnimation(.easeInOut(duration: 0.35)) { mode = .grounding }
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .animation(.easeOut(duration: 0.4).delay(0.36), value: appeared)
            }

            Rectangle().fill(Theme.divider).frame(height: 1)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.4), value: appeared)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
    }
}

private struct CalmOptionRow: View {
    let title: String
    let description: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title).font(.system(size: 17, weight: .semibold)).foregroundColor(Theme.primary)
                    Text(description).font(.system(size: 14, weight: .regular)).foregroundColor(Theme.secondary).lineSpacing(3).fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 13, weight: .medium)).foregroundColor(Theme.accent)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.vertical, 20)
        }
        .buttonStyle(.plain)
    }
}

private struct BreathingSessionView: View {
    let onDone: () -> Void
    @State private var phase: ExploreBreathPhase = .rest
    @State private var circleScale: CGFloat = 0.55
    @State private var cycles = 0
    @State private var animating = false
    @State private var showDone = false
    @State private var appeared = false
    private let targetCycles = 3

    var body: some View {
        VStack(spacing: 0) {
            if !showDone {
                HStack {
                    Button(action: onDone) {
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
            } else {
                Spacer().frame(height: 64)
            }

            Spacer()

            VStack(spacing: 10) {
                Text("Breathing").font(.system(size: 26, weight: .semibold, design: .serif)).foregroundColor(Theme.primary)
                Text("Three slow cycles. Follow the circle.").font(.system(size: 15)).foregroundColor(Theme.secondary)
            }
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

            Spacer()

            ZStack {
                Circle().fill(Theme.accent.opacity(0.07)).frame(width: 240, height: 240)
                Circle().fill(Theme.accent.opacity(0.13)).frame(width: 190, height: 190).scaleEffect(circleScale)
                Circle().fill(Theme.accent.opacity(0.28)).frame(width: 120, height: 120).scaleEffect(circleScale)
                Text(phase.label).font(.system(size: 16, weight: .medium)).foregroundColor(Theme.accentDeep).multilineTextAlignment(.center).animation(nil, value: phase.label)
            }
            .frame(width: 240, height: 240)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.2), value: appeared)

            Spacer()

            HStack(spacing: 10) {
                ForEach(0..<targetCycles, id: \.self) { i in
                    Circle().fill(i < cycles ? Theme.accent : Theme.divider).frame(width: 8, height: 8).animation(.easeInOut(duration: 0.3), value: cycles)
                }
            }
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)

            Spacer()

            VStack(spacing: 14) {
                if showDone {
                    Text("Well done.").font(.system(size: 15, weight: .medium)).foregroundColor(Theme.calmGreen).transition(.opacity)
                    Button(action: onDone) {
                        Text("Done").font(.system(size: 17, weight: .semibold)).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 16).background(Theme.accent).cornerRadius(Theme.buttonRadius)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .offset(y: 8)))
                } else if !animating {
                    Button {
                        animating = true
                        runCycle()
                    } label: {
                        Text("Start").font(.system(size: 17, weight: .semibold)).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 16).background(Theme.accent).cornerRadius(Theme.buttonRadius)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity)
                } else {
                    Color.clear.frame(height: 52)
                }
            }
            .frame(minHeight: 90)
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 52)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.35), value: appeared)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .onAppear { appeared = true }
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
                            circleScale = ExploreBreathPhase.rest.scale
                        }
                    }
                }
            }
        }
    }

    private func runPhase(_ next: ExploreBreathPhase, completion: @escaping () -> Void) {
        withAnimation(.none) { phase = next }
        let duration = (next == .inhale || next == .exhale) ? next.duration : 0.3
        withAnimation(.easeInOut(duration: duration)) { circleScale = next.scale }
        DispatchQueue.main.asyncAfter(deadline: .now() + next.duration) { completion() }
    }
}

private struct GroundingSessionView: View {
    let onDone: () -> Void
    @State private var stepIndex = 0
    @State private var stepVisible = false
    @State private var showDone = false
    @State private var appeared = false

    private var isLast: Bool { stepIndex == groundingSteps.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            if !showDone {
                HStack {
                    Button(action: onDone) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left").font(.system(size: 14, weight: .medium))
                            Text("Back").font(.system(size: 15, weight: .regular))
                        }
                        .foregroundColor(Theme.accent)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Text("\(stepIndex + 1) of \(groundingSteps.count)").font(.system(size: 12, weight: .regular)).foregroundColor(Theme.secondary)
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 64)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Theme.divider).frame(height: 2).cornerRadius(1)
                        Rectangle().fill(Theme.accent).frame(width: geo.size.width * (Double(stepIndex + 1) / Double(groundingSteps.count)), height: 2).cornerRadius(1).animation(.easeInOut(duration: 0.35), value: stepIndex)
                    }
                }
                .frame(height: 2)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
            } else {
                Spacer().frame(height: 64)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                Text("Grounding").font(.system(size: 11, weight: .semibold)).foregroundColor(Theme.accent).textCase(.uppercase).kerning(1.0)
                Rectangle().fill(Theme.divider).frame(height: 1)
                Text(groundingSteps[stepIndex]).font(.system(size: 22, weight: .medium, design: .serif)).foregroundColor(Theme.primary).lineSpacing(7).fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 24)
                Text("Take your time. Move on when you are ready.").font(.system(size: 14, weight: .regular)).foregroundColor(Theme.secondary).italic()
            }
            .padding(28)
            .frame(maxWidth: .infinity, minHeight: 270, alignment: .leading)
            .background(Theme.surface)
            .cornerRadius(Theme.cardRadius)
            .overlay(RoundedRectangle(cornerRadius: Theme.cardRadius).stroke(Theme.divider, lineWidth: 1))
            .shadow(color: Theme.cardShadow, radius: 18, x: 0, y: 6)
            .padding(.horizontal, Theme.screenPadding)
            .id(stepIndex)
            .opacity(stepVisible ? 1 : 0)
            .offset(x: stepVisible ? 0 : 28)
            .animation(.easeOut(duration: 0.35), value: stepVisible)

            Spacer()

            VStack(spacing: 14) {
                if showDone {
                    Text("Well done.").font(.system(size: 15, weight: .medium)).foregroundColor(Theme.calmGreen).transition(.opacity)
                    Button(action: onDone) {
                        Text("Done").font(.system(size: 17, weight: .semibold)).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 16).background(Theme.accent).cornerRadius(Theme.buttonRadius)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .offset(y: 8)))
                } else {
                    Button {
                        if isLast {
                            withAnimation { showDone = true }
                        } else {
                            advance()
                        }
                    } label: {
                        Text(isLast ? "Complete" : "Next").font(.system(size: 17, weight: .semibold)).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 16).background(Theme.accent).cornerRadius(Theme.buttonRadius)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 52)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.4).delay(0.3), value: appeared)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .onAppear {
            appeared = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeOut(duration: 0.35)) { stepVisible = true }
            }
        }
    }

    private func advance() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.easeOut(duration: 0.18)) { stepVisible = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            stepIndex += 1
            withAnimation(.easeOut(duration: 0.35)) { stepVisible = true }
        }
    }
}
