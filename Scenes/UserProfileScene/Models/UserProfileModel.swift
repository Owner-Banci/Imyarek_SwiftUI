// BEGIN Models.swift
import Foundation

public enum Gender1: String, Codable, CaseIterable {
    case male = "Мужской"
    case female = "Женский"
    case other = "Некто"
}

public enum Platform: String, Codable, CaseIterable, Identifiable {
    case telegram, instagram, vk
    public var id: Self { self }
    public var title: String {
        switch self {
        case .telegram:  return "Telegram"
        case .instagram: return "Instagram"
        case .vk:        return "VK"
        }
    }
}

public enum Interest: String, Codable, CaseIterable, Identifiable {
    case cinema, mountain, game, adventure, books, sport, anime, philosophy, culinary, technology
    public var id: Self { self }
    public var title: String {
        switch self {
        case .cinema:     return "Кино и сериалы"
        case .mountain:   return "Горы"
        case .game:       return "Игры"
        case .adventure:  return "Путешествия"
        case .books:      return "Книги"
        case .sport:      return "Спорт"
        case .anime:      return "Аниме"
        case .philosophy: return "Философия"
        case .culinary:   return "Кулинария"
        case .technology: return "Технологии"
        }
    }
}

public struct SocialLink: Identifiable, Codable, Equatable {
    public let id = UUID()
    public let platform: Platform
    public var url: String
}

public struct UserProfile: Codable {
    public var name: String
    public var age: Int
    public var gender: Gender1
    public var bio: String
    public var interests: [Interest]
    public var socialLinks: [SocialLink]
    public var photoName: String
}
// END Models.swift
