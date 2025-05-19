import SwiftUI
import Combine

// MARK: – ViewModel
@MainActor
final class UserProfileViewModel: ObservableObject {
    @Published private(set) var profile: UserProfile?

    private let interactor: UserProfileInteractor
    init(interactor: UserProfileInteractor) {
        self.interactor = interactor
        Task { await interactor.load() }
    }

    func tapped(platform: String) { Task { await interactor.open(platform) } }

    fileprivate func apply(_ profile: UserProfile) { self.profile = profile }
}

// MARK: – Contract Presenter
protocol UserProfilePresenter: AnyObject, Sendable {
    func present(profile: UserProfile) async
    func open(url: URL) async
}

// MARK: – Router
final class UserProfileRouter: UserProfilePresenter {
    weak var viewModel: UserProfileViewModel?

    @MainActor func present(profile: UserProfile) async { viewModel?.apply(profile) }
    @MainActor func open(url: URL) async              { await UIApplication.shared.open(url) }
}

