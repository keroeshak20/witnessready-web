import SwiftUI

struct CheckInView: View {
    @EnvironmentObject var appState: AppState
    @State private var step: Int = 0
    @State private var firstTime: Bool? = nil
    @State private var nervousness: NervousnessLevel? = nil
    @State private var mainWorries: Set<MainWorry> = []
    @State private var appeared = false

    private var showContinue: Bool {
        step >= 2 && !mainWorries.isEmpty
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 44) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Before we begin")
                            .font(.system(size: 30, weight: .semibold, design: .serif))
                            .foregroundColor(Theme.primary)
                        Text("A few short questions to help this experience feel right for you.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Theme.secondary)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 16)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

                    CheckInQuestion(
                        number: "01",
                        question: "Is this your first time testifying in court?"
                    ) {
                        HStack(spacing: 12) {
                            FirstTimeButton(label: "Yes, it is", isSelected: firstTime == true) {
                                selectFirstTime(true)
                            }
                            FirstTimeButton(label: "No, I have before", isSelected: firstTime == false) {
                                selectFirstTime(false)
                            }
                        }
                    }
                    .id("q1")
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.2), value: appeared)

                    if step >= 1 {
                        CheckInQuestion(
                            number: "02",
                            question: "How nervous do you feel right now?"
                        ) {
                            VStack(spacing: 10) {
                                ForEach(NervousnessLevel.allCases, id: \.self) { level in
                                    CheckInOptionButton(
                                        label: level.rawValue,
                                        isSelected: nervousness == level
                                    ) {
                                        selectNervousness(level)
                                    }
                                }
                            }
                        }
                        .id("q2")
                        .transition(.opacity.combined(with: .offset(y: 14)))
                    }

                    if step >= 2 {
                        CheckInQuestion(
                            number: "03",
                            question: "What are you most worried about?",
                            subtitle: "Select all that apply."
                        ) {
                            VStack(spacing: 10) {
                                ForEach(MainWorry.allCases, id: \.self) { worry in
                                    CheckInOptionButton(
                                        label: worry.rawValue,
                                        isSelected: mainWorries.contains(worry)
                                    ) {
                                        toggleWorry(worry)
                                    }
                                }
                            }
                        }
                        .id("q3")
                        .transition(.opacity.combined(with: .offset(y: 14)))
                    }

                    if showContinue {
                        Button {
                            appState.isFirstTime = firstTime
                            appState.mainWorries = mainWorries
                            appState.navigate(to: .calm)
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
                        .id("continue")
                        .transition(.opacity.combined(with: .offset(y: 10)))
                    }

                    Spacer(minLength: 52)
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 64)
            }
            .onChange(of: step) { newStep in
                withAnimation(.easeOut(duration: 0.5)) {
                    switch newStep {
                    case 1:
                        proxy.scrollTo("q2", anchor: .top)
                    case 2:
                        proxy.scrollTo("q3", anchor: .top)
                    default:
                        break
                    }
                }
            }
            .onChange(of: showContinue) { show in
                if show {
                    withAnimation(.easeOut(duration: 0.5)) {
                        proxy.scrollTo("continue", anchor: .center)
                    }
                }
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .onAppear { appeared = true }
    }

    private func selectFirstTime(_ value: Bool) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        firstTime = value

        withAnimation(.easeOut(duration: 0.25)) {
            nervousness = nil
            mainWorries = []
            step = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation(.easeOut(duration: 0.4)) { step = 1 }
        }
    }

    private func selectNervousness(_ level: NervousnessLevel) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        nervousness = level
        appState.nervousness = level

        withAnimation(.easeOut(duration: 0.25)) {
            mainWorries = []
            step = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation(.easeOut(duration: 0.4)) { step = 2 }
        }
    }

    private func toggleWorry(_ worry: MainWorry) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        withAnimation(.easeInOut(duration: 0.2)) {
            if mainWorries.contains(worry) {
                mainWorries.remove(worry)
            } else {
                mainWorries.insert(worry)
            }
        }
    }
}

struct CheckInQuestion<Content: View>: View {
    let number: String
    let question: String
    var subtitle: String? = nil
    let content: Content

    init(number: String, question: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.number = number
        self.question = question
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 10) {
                Text(number)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.accent)
                    .kerning(0.5)
                    .padding(.top, 3)

                VStack(alignment: .leading, spacing: 4) {
                    Text(question)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Theme.primary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)

                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Theme.secondary)
                    }
                }
            }

            content
        }
    }
}

struct FirstTimeButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : Theme.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isSelected ? Theme.accent : Theme.surface)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? Theme.accent : Theme.divider, lineWidth: 1))
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct CheckInOptionButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Theme.accent : Theme.primary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.accent)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(isSelected ? Theme.accent.opacity(0.08) : Theme.surface)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? Theme.accent.opacity(0.4) : Theme.divider, lineWidth: 1))
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
