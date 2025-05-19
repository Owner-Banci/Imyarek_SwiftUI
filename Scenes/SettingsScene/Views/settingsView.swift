import SwiftUI



// MARK: – Основной экран

struct SettingsView: View {
    
    // Профиль
    @State private var userNickName     = "Имя"
    @State private var userGenderString = "Женский"
    @State private var userProfileImage = "swift"
    
    // Навигация
    @State private var navigateToSecondView = false
    @State private var showDatingProfile    = false
    
    //    // Фильтры
//        @State private var userSelectedGender        = UserGender.female
//        @State private var userSelectedAge           = UserAge.from22to25
//        @State private var interlocutorSelectedGender = UserGender.male
//        @State private var interlocutorSelectedAge    = UserAge.from22to25
    
    @State private var userSelectedAge: userAge?
    @State private var userSelectedGender: userGender?
    @State private var interlocutorSelectedAge: userAge?
    @State private var interlocutorSelectedGender: userGender?
    
    
    enum userGender: String, CaseIterable, Identifiable {
        case
        male,
        female,
        someone
        
        var id: Self { self }
    }
    
    enum userAge: String, CaseIterable, Identifiable {
        case
        until17 = "до 17 лет",
        from18To21 = "от 18 до 21 года",
        from22to25 = "от 22 до 25 лет",
        from26to35 = "от 26 до 35 лет",
        olderThan36 = "старше 36"
        
        var id: Self { self }
    }
    // Пункты «Анкета / Любимый фильтр / Прошлый фильтр»
    private var settingElements: [SettingItem] {
        [
            .init(title: "Анкета", action: { showDatingProfile = true }),
            .init(title: "Любимый фильтр", action: {
                userSelectedGender         = .female
                userSelectedAge            = .from22to25
                interlocutorSelectedGender = .male
                interlocutorSelectedAge    = .from22to25
            }),
            .init(title: "Прошлый фильтр", action: {
                userSelectedGender         = .male
                userSelectedAge            = .from18To21
                interlocutorSelectedGender = .female
                interlocutorSelectedAge    = .from18To21
            }),
        ]
    }
    
    let sampleProfile = UserProfile(
        name: "Марина",
        age: 20,
        gender: .female,
        bio: "Люблю активный отдых, горы и хорошие фильмы.",
        interests: [
            Interest.adventure, Interest.anime
        ],
        socialLinks: [
            SocialLink(platform: .vk, url: "vk.com/marina1"),
            SocialLink(platform: .instagram, url: "https://www.instagram.com/i_mish_a"),
            SocialLink(platform: .telegram, url: "https://t.me/Murtazaev_Av")
        ],
        photoName: "person.crop.circle"
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: — Шапка
                    HStack {
                        Spacer()
                        Button("Изменить") {
                            navigateToSecondView = true
                        }
                        .foregroundColor(.red)
                        .padding(.trailing, 20)
                    }
                    
                    // MARK: — Аватар + имя + пол
                    VStack(spacing: 8) {
                        Image(systemName: userProfileImage)
                            .resizable()
                            .frame(width: 130, height: 130)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(Circle())
                        Text(userNickName)
                            .font(.title)
                        Text(userGenderString)
                            .font(.title2)
                    }
                    
                    // MARK: — О себе
                    VStack(alignment: .leading, spacing: 4) {
                        Text("О себе")
                            .font(.headline)
                        Text("Тут должно быть описание пользователя")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.label).opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // MARK: — Список радио-кнопок
                    VStack(spacing: 0) {
                        ForEach(settingElements) { item in
                            Button {
                                item.action()
                            } label: {
                                HStack {
                                    Image(systemName: "circle")
                                    Text(item.title)
                                    Spacer()
                                }
                                .padding(10)
                            }
                            .background(Color(.secondarySystemBackground))
                            .overlay(
                                Rectangle()
                                    .frame(height: item.id == settingElements.last!.id ? 0 : 1)
                                    .foregroundColor(Color(.label).opacity(0.1)),
                                alignment: .bottom
                            )
                            
                        }
                        .cornerRadius(20)
                        .foregroundStyle(Color(.label))
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)
                    
                    
                    // MARK: — Персональные настройки
                    //                    filterSection(
                    //                        title: "Персональные настройки",
                    //                        description: "Укажите свой пол и возраст и мы найдём вам более подходящих собеседников",
                    //                        gender: $userSelectedGender,
                    //                        age: $userSelectedAge
                    //                    )
                    
                    // MARK: — Настройки собеседника
                    //                    filterSection(
                    //                        title: "Настройки собеседника",
                    //                        description: "Укажите пол и возраст собеседника",
                    //                        gender: $interlocutorSelectedGender,
                    //                        age: $interlocutorSelectedAge
                    //                    )
                    //                    filterSection(
                    //                        title: "Персональные настройки",
                    //                        description: "Укажите свой пол и возраст и мы найдём вам более подходящих собеседников",
                    //                        gender: $userSelectedGender,
                    //                        age: $userSelectedAge
                    //                    )
                    //
                    //                    filterSection(
                    //                        title: "Настройки собеседника",
                    //                        description: "Укажите пол и возраст собеседника",
                    //                        gender: $interlocutorSelectedGender,
                    //                        age: $interlocutorSelectedAge
                    //                    )

                    
                    userFilterSettingsView(
                        title: "Персональные настройки",
                        description: "Укажите свой пол и возраст и мы найдём вам более подходящих собеседников",
                        gender: $userSelectedGender,
                        age: $userSelectedAge
                    )
                    
                    userFilterSettingsView(
                        title: "Настройки собеседника",
                        description: "Укажите пол и возраст собеседника",
                        gender: $interlocutorSelectedGender,
                        age: $interlocutorSelectedAge
                    )
                    
                    
                }
                .padding(.vertical)
            }
            .navigationDestination(isPresented: $navigateToSecondView) {
                UserSettingsModule.build()
            }
            .navigationDestination(isPresented: $showDatingProfile) {
                UserProfileModule.build()
            }
        }
    }
    
    // MARK: — Блок «Пол + Возраст»
    func userFilterSettingsView(
        title: String,
        description: String,
        gender: Binding<userGender?>,
        age: Binding<userAge?>
    ) -> some View {
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.system(size: 16, weight: .regular))
                .padding(.horizontal, 30)
            Text(description)
                .font(.system(size: 12, weight: .thin))
                .padding(.horizontal, 30)
            
            Picker(selection: gender) {
                Text("Мужской").tag(userGender.male)
                Text("Женский").tag(userGender.female)
                Text("Некто").tag(userGender.someone)
            } label: {
                Text("")
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 370)
            .padding(.horizontal, 25)
            
            List {
                Picker(selection: age) {
                    ForEach(userAge.allCases, id: \.self) { age in
                        Text(age.rawValue).tag(age)
                    }
                } label: {
                    Text("Возраст")
                        .foregroundColor(Color(.label))
                    Text("Укажите свой возраст")
                        .foregroundColor(Color(.label))
                }
                .tint(Color(.label))
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGroupedBackground))
                )
            }
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
            .padding(.horizontal, 25)
            .frame(width: 420, height: 90)
        }
        .frame(maxWidth: 360, maxHeight: 350)
        .padding(.horizontal, 25)
    }
}

// MARK: — Preview

#Preview {
    SettingsView()
}
