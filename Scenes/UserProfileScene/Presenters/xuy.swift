// BEGIN UserSettingsPresenter.swift
import SwiftUI
import Combine
import PhotosUI


protocol UserSettingsPresenter: AnyObject, Sendable {
    func present(profile: UserProfile) async
    func presentSaved() async
}

@MainActor
final class UserSettingsViewModel: ObservableObject {
    // основные поля профиля
    @Published var name = ""
    @Published var bio  = ""
    @Published var age  = 18
    @Published var interests = Set<Interest>()

    // соц-сети
    @Published var links: [SocialLink] = []
    @Published var selectedPlatform: Platform?
    @Published var linkURL: String = ""

    // UI-состояния
    @Published var showSaveBanner = false
    
    @Published var image: UIImage? = nil


    private let interactor: UserSettingsInteractor
    init(interactor: UserSettingsInteractor) { self.interactor = interactor }

    // MARK: – Жизненный цикл
    func onAppear() {
        Task {
            await interactor.load()

            if let name = await interactor.getCurrentPhotoName(),
               let image = FileManager.default.loadImage(named: name) {
                await MainActor.run { self.image = image }
            }
        }
    }

    // MARK: – действия View
    func nicknameTapped() { Task { await interactor.generateNickname() } }
    func toggle(_ i: Interest) { Task { await interactor.toggle(i) } }
    func saveTapped() { Task { await interactor.save() } }
    func ageSelected(_ n: Int) { Task { await interactor.update { $0.age = n } } }
    func bioChanged(_ t: String) { Task { await interactor.update { $0.bio = t } } }
    func nameChanged(_ t: String) { Task { await interactor.update { $0.name = t } } }

    // MARK: – Соц-ссылки
    func linkButtonTapped(_ platform: Platform) {
        linkURL = links.first(where: { $0.platform == platform })?.url ?? ""
        selectedPlatform = platform
    }

    func saveLink() {
        guard let platform = selectedPlatform else { return }
        if let idx = links.firstIndex(where: { $0.platform == platform }) {
            links[idx].url = linkURL
        } else {
            links.append(SocialLink(platform: platform, url: linkURL))
        }
        Task { await interactor.update { $0.socialLinks = links } }
        selectedPlatform = nil
    }

    func cancelLink() { selectedPlatform = nil }

    // MARK: – Presenter callbacks
    fileprivate func apply(_ p: UserProfile) {
        name = p.name
        bio  = p.bio
        age  = p.age
        interests = Set(p.interests)
        links = p.socialLinks
    }
    
    func handleImageSelection(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                await MainActor.run { self.image = UIImage(data: data) }
                await interactor.updateImageData(data)
            }
        } catch {
            print("Ошибка загрузки изображения: \(error)")
        }
    }
    


}

final class UserSettingsRouter: UserSettingsPresenter {
    weak var viewModel: UserSettingsViewModel?

    @MainActor func present(profile: UserProfile) async { viewModel?.apply(profile) }
    @MainActor func presentSaved() async { viewModel?.showSaveBanner = true }
}
// END UserSettingsPresenter.swift

// BEGIN LinkInputSheet.swift


struct LinkInputSheet: View {
    let platform: Platform
    @Binding var url: String
    let onSave: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ссылка для \(platform.title)")) {
                    TextField("https://…", text: $url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            .navigationTitle(platform.title)
            .navigationBarItems(
                leading: Button("Отмена", action: onCancel),
                trailing: Button("Сохранить", action: onSave)
                    .disabled(url.isEmpty)
            )
        }
    }
}
// END LinkInputSheet.swift
