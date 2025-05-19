// BEGIN UserSettingsLogic.swift
import Foundation

protocol UserSettingsInteractor: Actor {
    func load() async
    func update(_ mutate: (inout UserProfile) -> Void) async
    func toggle(_ interest: Interest) async
    func generateNickname() async
    func save() async
    func updateImageData(_ data: Data) async
    func getCurrentPhotoName() async -> String?

}

actor UserSettingsLogic: UserSettingsInteractor {
    private let presenter: UserSettingsPresenter
    private var draft: UserProfile?
    private let db = DatabaseService.shared

    init(presenter: UserSettingsPresenter) { self.presenter = presenter }

    func load() async {
        do {
            draft = try await db.fetchUserProfile()
            // если нет соц-ссылок — создаём заглушки
            if draft?.socialLinks.isEmpty ?? true {
                draft?.socialLinks = Platform.allCases
                    .map { SocialLink(platform: $0, url: "") }
            }
            if let d = draft { await presenter.present(profile: d) }
        } catch { /* обработка */ }
    }

    func update(_ mutate: (inout UserProfile) -> Void) async {
        guard var d = draft else { return }
        mutate(&d)
        draft = d
        await presenter.present(profile: d)
    }

    func toggle(_ interest: Interest) async {
        await update { profile in
            var set = Set(profile.interests)
            if set.contains(interest) { set.remove(interest) }
            else { set.insert(interest) }
            profile.interests = Array(set)
        }
    }

    func generateNickname() async {
        await update { $0.name = NicknameGenerator.generate() }
    }

    func save() async {
        guard let d = draft else { return }
        do {
            try await db.saveUserProfile(d)
            await presenter.presentSaved()
        } catch { /* обработка */ }
    }
    
    func updateImageData(_ data: Data) async {
        await update { profile in
            let imageName = "user_photo_\(UUID().uuidString).jpg"
            profile.photoName = imageName
            try? FileManager.default.saveImageData(data, withName: imageName)
        }
    }

    func getCurrentPhotoName() async -> String? {
        return draft?.photoName
    }
}

enum NicknameGenerator {
    static func generate() -> String {
        let adj  = ["Swift","Happy","Crazy","Lucky","Sneaky","Brave","Cool","Mighty"].randomElement()!
        let noun = ["Tiger","Eagle","Panda","Lion","Shark","Falcon","Wolf","Bear"].randomElement()!
        return "\(adj)\(noun)\(Int.random(in: 1...999))"
    }
}
// END UserSettingsLogic.swift
