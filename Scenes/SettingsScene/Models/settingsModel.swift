import SwiftUI

struct SettingsViewModel {
    var userName: String
    var userGender: String
    var favoriteFilter: FilterState
    var lastFilter: FilterState
}

struct FilterState {
    let userGender: Gender?
    let userAge: Age?
    let interlocutorGender: Gender?
    let interlocutorAge: Age?
}

enum Gender: String, CaseIterable, Identifiable {
    case male = "Мужской"
    case female = "Женский"
    case someone = "Некто"
    var id: String { rawValue }
}

enum Age: String, CaseIterable, Identifiable {
    case until17 = "до 17 лет"
    case from18To21 = "от 18 до 21 года"
    case from22to25 = "от 22 до 25 лет"
    case from26to35 = "от 26 до 35 лет"
    case olderThan36 = "старше 36"
    var id: String { rawValue }
}

struct SettingItem: Identifiable {
    let id = UUID()
    let title: String
    let action: () -> Void
}
