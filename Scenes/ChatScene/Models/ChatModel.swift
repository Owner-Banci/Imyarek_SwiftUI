

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isCurrentUser: Bool
}

struct ChatUser {
    let id: String
    let nickname: String
    let age: Int
    let gender: String
}

struct ChatFilter {
    var gender: String?
    var ageRange: ClosedRange<Int>?
    var isRandom: Bool
}

enum ComplaintReason: String, CaseIterable {
    case content18 = "Контент 18+"
    case spam = "Спам"
    case offrnsive = "Оскорбительное поведение"
    case cheating = "Мошенничество"
}

enum ChatBottomState {
    case typing                // обычный режим — TextField + клавиатура
    case actions               // режим «три кнопки»
    case ended                 // чат завершён — другие три кнопки + надпись
}
