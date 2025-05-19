// BEGIN UserSettingsView.swift
import SwiftUI
import PhotosUI

struct UserSettingsView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @StateObject var viewModel: UserSettingsViewModel
    @State private var showAgePicker = false
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        VStack {
            HStack { Spacer(); saveButton }
            ScrollView {

                profileImage

                nicknameSection
                randomNameButton.padding(.bottom, 20)

                bioSection.padding(.bottom, 20)
                ageSection.padding(.bottom, 20)

                socialLinksSection.padding(.bottom, 20)
                interestsSection
                Spacer()
            }
        }
        .onAppear { viewModel.onAppear() }
        .alert("Сохранено!", isPresented: $viewModel.showSaveBanner) {
            Button("OK", role: .cancel) {}
        }
        .sheet(isPresented: $showAgePicker) { agePicker }
        .sheet(item: $viewModel.selectedPlatform) { platform in
            LinkInputSheet(
                platform: platform,
                url: $viewModel.linkURL,
                onSave: { viewModel.saveLink() },
                onCancel: { viewModel.cancelLink() }
            )
        }
    }

    // MARK: – Header
    private var saveButton: some View {
        Button("Сохранить") { viewModel.saveTapped() }
            .foregroundColor(.red)
            .padding(.horizontal, 25)
    }


    var profileImage: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 130, height: 130)
                    .cornerRadius(65)
                    .padding(.top, 25)
            } else {
                Text("Изображение не выбрано")
                    .foregroundColor(.gray)
                    .padding()
            }

            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Изменить фотографию")
                    .foregroundColor(Color(.label))
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    await viewModel.handleImageSelection(newItem)
                }
            }
        }
        .padding()
    }



    // MARK: – Nickname
    private var nicknameSection: some View {
        VStack(alignment: .leading) {
            Text("Никнейм: \(viewModel.name)")
            Text("Никнейм будет отображён в анкете")
                .font(.footnote)
            TextField("Введите никнейм…",
                      text: Binding(get: { viewModel.name },
                                     set: viewModel.nameChanged))
                .textFieldStyle(.roundedBorder)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.label).opacity(0.4), lineWidth: 1))
        }
        .padding(.horizontal, 25)
    }
    private var randomNameButton: some View {
        Button("СЛУЧАЙНЫЙ НИКНЕЙМ") { viewModel.nicknameTapped() }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.label).opacity(0.4), lineWidth: 1))
            .padding(.horizontal, 25)
            .foregroundColor(Color(.label))
    }

    // MARK: – Bio
    private var bioSection: some View {
        VStack(alignment: .leading) {
            Text("О себе")
            Text("Напиши пару слов о себе, чтобы заинтересовать собеседника")
                .font(.footnote)
            TextField("О себе",
                      text: Binding(get: { viewModel.bio },
                                     set: viewModel.bioChanged))
                .textFieldStyle(.roundedBorder)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.label).opacity(0.4), lineWidth: 1))
        }
        .padding(.horizontal, 25)
    }

    // MARK: – Age
    private var ageSection: some View {
        VStack(alignment: .leading) {
            Text("Ваш возраст: \(viewModel.age)")
            Text("Укажите свой возраст для анкеты")
                .font(.footnote)
            Button("УКАЖИТЕ ВОЗРАСТ") { showAgePicker = true }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.label).opacity(0.4), lineWidth: 1))
                .foregroundColor(Color(.label))
        }
        .padding(.horizontal, 25)
    }
    
    private var agePicker: some View {
        VStack(spacing: 0) {
            Text("Выберите ваш возраст")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
            Divider()
            Picker("Возраст", selection: Binding(
                get: { viewModel.age },
                set: viewModel.ageSelected
            )) {
                ForEach(10..<100, id: \.self) { Text("\($0)").tag($0) }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(height: 150)
            Divider()
            Button("OK") { showAgePicker = false }
                .frame(maxWidth: .infinity)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16).padding()
    }

    // MARK: – Social links
    private var socialLinksSection: some View {
        VStack(alignment: .leading) {
            Text("Укажите ссылки")
            Text("Укажите ссылки на свои соц. сети")
                .font(.footnote)
                .padding(.bottom, 10)
            HStack {
                ForEach(Platform.allCases) { platform in
                    Button {
                        viewModel.linkButtonTapped(platform)
                    } label: {
                        Image(platform.rawValue)     // добавьте картинки в Assets
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding()
                            .background(.white)
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color(.label).opacity(0.7), lineWidth: 2)
                            )
                            .padding(5)
                    }
                    Divider()
                    
                }
            }

        }


    }

    // MARK: – Interests
    private var interestsSection: some View {
        VStack(alignment: .leading) {
            Text("Интересы")
            Text("Укажите ваши интересы для анкеты")
                .font(.footnote)
            ForEach(Interest.allCases) { i in
                Button { viewModel.toggle(i) } label: {
                    HStack (spacing: 0){
                        Text(i.title)
                        Spacer()
                        if viewModel.interests.contains(i) {
                            Image(systemName: "checkmark").foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(Color(.label))
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.label).opacity(0.4), lineWidth: 1))
                }
            }
        }
        .padding(.horizontal, 25)
    }
}
// END UserSettingsView.swift

// BEGIN UserSettingsModule.swift

enum UserSettingsModule {
    @MainActor
    static func build() -> some View {
        let router     = UserSettingsRouter()
        let interactor = UserSettingsLogic(presenter: router)
        let viewModel  = UserSettingsViewModel(interactor: interactor)
        router.viewModel = viewModel
        return UserSettingsView(viewModel: viewModel)
    }
}
// END UserSettingsModule.swift
//
#Preview {
    UserSettingsModule.build()
}
