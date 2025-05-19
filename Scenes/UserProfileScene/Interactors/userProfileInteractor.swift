import Foundation

protocol UserProfileInteractor: Actor {
    func load() async
    func open(_ platform: String) async
}

/// Потокобезопасная бизнес-логика
actor UserProfileLogic: UserProfileInteractor {
    private let presenter: UserProfilePresenter
    private let db = DatabaseService.shared
    private var profile: UserProfile?

    init(presenter: UserProfilePresenter) { self.presenter = presenter }

    func load() async {
        do {
            let profile = try await db.fetchUserProfile()
            self.profile = profile
            await presenter.present(profile: profile)
        } catch {
            // TODO: обработать ошибку (alert / log)
        }
    }

    func open(_ platform: String) async {
        guard let link = profile?.socialLinks.first(where: { $0.platform.rawValue == platform }),
              let url  = URL(string: link.url) else { return }
        await presenter.open(url: url)
    }
}

