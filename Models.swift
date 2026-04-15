import Foundation

enum CardType {
    case question
    case reminder
}

struct PracticeCard: Identifiable {
    let id = UUID()
    let type: CardType
    let content: String
}

enum PracticeCategory: String, CaseIterable {
    case full = "Full session"
    case opening = "Opening questions"
    case events = "Describing events"
    case followUp = "Follow-up questions"
    case uncertainty = "Uncertain moments"

    var description: String {
        switch self {
        case .full:
            return "Work through the complete set of witness questions from start to finish."
        case .opening:
            return "Practice introducing yourself and establishing your connection to events."
        case .events:
            return "Practice walking through what you observed and what happened."
        case .followUp:
            return "Practice answering questions about details, location, and timing."
        case .uncertainty:
            return "Practice responding honestly when you are unsure or cannot recall something."
        }
    }
}

extension PracticeCard {
    static let baseDeck: [PracticeCard] = [
        PracticeCard(type: .reminder, content: "You are here to tell what you know. Nothing more. Nothing less. Take each question one at a time."),
        PracticeCard(type: .question, content: "Please state your name for the court."),
        PracticeCard(type: .question, content: "How are you connected to the events you are here to describe?"),
        PracticeCard(type: .question, content: "Where were you on the day in question?"),
        PracticeCard(type: .question, content: "Can you tell the court what you personally observed?"),
        PracticeCard(type: .reminder, content: "Pause before answering. Take a breath. There is no rush."),
        PracticeCard(type: .question, content: "What happened next?"),
        PracticeCard(type: .question, content: "Can you describe the sequence of events as you remember them?"),
        PracticeCard(type: .question, content: "What did you see or hear?"),
        PracticeCard(type: .question, content: "Who else was present at that time?"),
        PracticeCard(type: .reminder, content: "If you do not understand a question, ask for it to be repeated. This is completely acceptable."),
        PracticeCard(type: .question, content: "Where exactly did this take place?"),
        PracticeCard(type: .question, content: "When did you first notice something significant?"),
        PracticeCard(type: .question, content: "Why did that particular moment stand out to you?"),
        PracticeCard(type: .question, content: "What do you remember most clearly from that time?"),
        PracticeCard(type: .reminder, content: "Do not guess. If you are not certain, say so. \"I do not recall\" is a complete and honest answer."),
        PracticeCard(type: .question, content: "Is there anything about the events you are not fully certain about?"),
        PracticeCard(type: .question, content: "Are there details you cannot recall exactly?"),
        PracticeCard(type: .question, content: "What would you do if you were asked something you do not remember?"),
        PracticeCard(type: .reminder, content: "Answer in your own words. Speak slowly and clearly. You have all the time you need.")
    ]

    static func buildDeck(worries: Set<MainWorry>, isFirstTime: Bool?) -> [PracticeCard] {
        var result: [PracticeCard] = []
        result.append(baseDeck[0])

        if worries.contains(.freezing) {
            result.append(PracticeCard(type: .reminder, content: "You mentioned worrying about freezing. If that happens, take a breath. Ask for the question to be repeated. You are allowed to take a moment."))
        }
        if worries.contains(.forgetting) {
            result.append(PracticeCard(type: .reminder, content: "You mentioned worrying about forgetting. If you cannot remember something, say so honestly. \"I do not recall\" is a complete answer. Never guess."))
        }
        if worries.contains(.beingJudged) {
            result.append(PracticeCard(type: .reminder, content: "You mentioned worrying about being judged. You are not on trial. You are there to share what you know. Answer honestly and the rest is not your concern."))
        }
        if worries.contains(.sayingWrong) {
            result.append(PracticeCard(type: .reminder, content: "You mentioned worrying about saying something wrong. If you realize you misspoke, you may clarify. An honest correction is always better than leaving an error."))
        }
        if worries.contains(.unknowing) {
            result.append(PracticeCard(type: .reminder, content: "You mentioned not knowing what to expect. You have already read through what the experience looks like. You are more prepared than you realize."))
        }
        if isFirstTime == true {
            result.append(PracticeCard(type: .reminder, content: "As a first-time witness, remember that no one expects perfection. They expect honesty. That is something you can give."))
        }

        result.append(contentsOf: baseDeck.dropFirst())
        return result
    }

    static func buildCategoryDeck(_ category: PracticeCategory) -> [PracticeCard] {
        switch category {
        case .full:
            return baseDeck
        case .opening:
            return [
                PracticeCard(type: .reminder, content: "Take your time with each question. Clear and direct is always better than long."),
                PracticeCard(type: .question, content: "Please state your name for the court."),
                PracticeCard(type: .question, content: "How are you connected to the events you are here to describe?"),
                PracticeCard(type: .question, content: "Where were you on the day in question?"),
                PracticeCard(type: .question, content: "Can you tell the court what you personally observed?"),
                PracticeCard(type: .reminder, content: "Answer only what was asked. Stop when the answer is complete.")
            ]
        case .events:
            return [
                PracticeCard(type: .reminder, content: "Describe what you personally saw or heard. Speak only from your own experience."),
                PracticeCard(type: .question, content: "What happened next?"),
                PracticeCard(type: .question, content: "Can you describe the sequence of events as you remember them?"),
                PracticeCard(type: .question, content: "What did you see or hear?"),
                PracticeCard(type: .question, content: "Who else was present at that time?"),
                PracticeCard(type: .reminder, content: "Pause before answering. Take a breath. There is no rush.")
            ]
        case .followUp:
            return [
                PracticeCard(type: .reminder, content: "Listen to the full question before you begin to answer."),
                PracticeCard(type: .question, content: "Where exactly did this take place?"),
                PracticeCard(type: .question, content: "When did you first notice something significant?"),
                PracticeCard(type: .question, content: "Why did that particular moment stand out to you?"),
                PracticeCard(type: .question, content: "What do you remember most clearly from that time?"),
                PracticeCard(type: .reminder, content: "If you do not understand a question, ask for it to be repeated.")
            ]
        case .uncertainty:
            return [
                PracticeCard(type: .reminder, content: "Honesty about what you do not know is just as important as what you do know."),
                PracticeCard(type: .question, content: "Is there anything about the events you are not fully certain about?"),
                PracticeCard(type: .question, content: "Are there details you cannot recall exactly?"),
                PracticeCard(type: .question, content: "What would you do if you were asked something you do not remember?"),
                PracticeCard(type: .reminder, content: "\"I do not recall\" is a complete and honest answer. Never guess.")
            ]
        }
    }
}
