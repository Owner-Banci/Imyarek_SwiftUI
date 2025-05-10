//import SwiftUI
//
//struct UserSettingsView: View {
//    
//    @State private var userSelectedAge: userAge?
//    @State private var userSelectedGender: userGender?
//    @State private var interlocutorSelectedAge: userAge?
//    @State private var interlocutorSelectedGender: userGender?
//    @State private var nicknameTextField: String = ""
//    @State private var descriptionTextField: String = ""
//    
//    enum userGender: String, CaseIterable, Identifiable {
//        case
//        male,
//        female,
//        someone
//        
//        var id: Self { self }
//    }
//    
//    enum userAge: String, CaseIterable, Identifiable {
//        case
//        until17 = "до 17 лет",
//        from18To21 = "от 18 до 21 года",
//        from22to25 = "от 22 до 25 лет",
//        from26to35 = "от 26 до 35 лет",
//        olderThan36 = "старше 36"
//        
//        var id: Self { self }
//    }
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Spacer()
//                settingsSaveButton
//            }
//            ScrollView {
//                profileImage
//                profileImageChangeButton
//                    .padding(.bottom, 25)
//                
//                nicknameChangeSection
//                randomNicknameButton
//                    .padding(.bottom, 25)
//                
//                userDescriptionChangeSection
//                    .padding(.bottom, 25)
//                
//                userFilterSettingsView(
//                    title: "Персональные настройки",
//                    description: "Укажите свой пол и возраст и мы найдём вам более подходящих собеседников",
//                    gender: $userSelectedGender,
//                    age: $userSelectedAge
//                )
//                
//                userFilterSettingsView(
//                    title: "Настройки собеседника",
//                    description: "Укажите пол и возраст собеседника",
//                    gender: $interlocutorSelectedGender,
//                    age: $interlocutorSelectedAge
//                )
//                
//                quickSettingsButton(
//                    title: "Любимая настройка:",
//                    subtitle: "Ниже указана самая часто используемая настройка."
//                )
//                .padding(.bottom, 15)
//                
//                quickSettingsButton(
//                    title: "Предыдущая настройка:",
//                    subtitle: "Ниже указаны ваши предыдущие настройки."
//                )
//                Spacer()
//            }
//        }
//        .padding() // Например, 44 для стандартной высоты status bar
////        .ignoresSafeArea()
////        .background(Color.green)
//    }
//    
//    var settingsSaveButton: some View {
//        Button(action: {}) {
//            Text("Сохранить")
//                .foregroundColor(Color.red)
//                .padding(.horizontal, 10)
//        }
//    }
//    
//    
//    var profileImage: some View {
//        Image(systemName: "swift")
//            .resizable()
//            .frame(width: 130, height: 130)
//            .background(Color.blue)
//            .cornerRadius(65)
//            .padding(.top, 20)
//    }
//    
//    var profileImageChangeButton: some View {
//        Button(action: {}) {
//            Text("Изменить фотографию")
//                .font(.body)
//                .foregroundColor(Color(.label))
//        }
//    }
//    
//    var nicknameChangeSection: some View {
//        VStack(alignment: .leading) {
//            Text("Никнейм")
//                .font(.system(size: 16, weight: .regular))
//            Text("Никнейм будет отображён в чате")
//                .font(.system(size: 12, weight: .thin))
//            
//            TextField("Введите никнейм...", text: $nicknameTextField)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .cornerRadius(20)
//                .overlay( // контур
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color(.label).opacity(0.4), lineWidth: 1)
//                )
//
//        }
//        .padding(.horizontal, 25)
//    }
//    
//    var randomNicknameButton: some View {
//        Button(action: {}) {
//            Text("СЛУЧАЙНЫЙ НИКНЕЙМ")
//                .font(.body)
//                .padding(.vertical, 10)
//        }
//        .frame(maxWidth: .infinity)
//        .background(Color(.systemGroupedBackground))
//        .foregroundColor(Color(.label))
//        .cornerRadius(20)
//        .overlay( // контур
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color(.label).opacity(0.4), lineWidth: 1)
//        )
//        .padding(.horizontal, 25)
//    }
//    
//    var userDescriptionChangeSection: some View {
//        VStack(alignment: .leading) {
//            Text("О себе")
//                .font(.system(size: 16, weight: .regular))
//            Text("Напиши пару слов о себе, чтобы заинтересовать собеседника")
//                .font(.system(size: 12, weight: .thin))
//            
//            TextField("О себе", text: $descriptionTextField)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .background(Color.black)
//                .cornerRadius(20)
//                .overlay( // контур
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color(.label).opacity(0.4), lineWidth: 1)
//                )
//        }
//        .padding(.horizontal, 25)
//    }
//    
//    func userFilterSettingsView(
//        title: String,
//        description: String,
//        gender: Binding<userGender?>,
//        age: Binding<userAge?>
//    ) -> some View {
//        VStack(alignment: .leading) {
//            
//            Text(title)
//                .font(.system(size: 16, weight: .regular))
//                .padding(.horizontal, 30)
//            Text(description)
//                .font(.system(size: 12, weight: .thin))
//                .padding(.horizontal, 30)
//            
//            Picker(selection: gender) {
//                Text("Мужской").tag(userGender.male)
//                Text("Женский").tag(userGender.female)
//                Text("Некто").tag(userGender.someone)
//            } label: {
//                Text("")
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .frame(width: 370)
//            .padding(.horizontal, 25)
//            
//            List {
//                Picker(selection: age) {
//                    ForEach(userAge.allCases, id: \.self) { age in
//                        Text(age.rawValue).tag(age)
//                    }
//                } label: {
//                    Text("Возраст")
//                        .foregroundColor(Color(.label))
//                    Text("Укажите свой возраст")
//                        .foregroundColor(Color(.label))
//                }
//                .tint(Color(.label))
//                .listRowBackground(
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color(.systemGroupedBackground))
//                )
//            }
//            .scrollContentBackground(.hidden)
//            .listStyle(PlainListStyle())
//            .padding(.horizontal, 25)
//            .frame(width: 420, height: 90)
//        }
//        .frame(maxWidth: 360, maxHeight: 350)
//        .padding(.horizontal, 25)
//    }
//    
//    func quickSettingsButton(title: String, subtitle: String) -> some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .font(.system(size: 16, weight: .regular))
//                .padding(.horizontal, 2)
//            Text(subtitle)
//                .font(.system(size: 12, weight: .thin))
//                .padding(.horizontal, 2)
//            
//            Button(action: {}) {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Свой: Пол: $пол, возраст: $возраст")
//                        .font(.subheadline)
//                        .foregroundColor(Color(.label))
//                    Text("Собеседника: $пол, возраст: $возраст")
//                        .font(.subheadline)
//                        .foregroundColor(Color(.label))
//                }
//                .padding(10)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(Color(.systemGroupedBackground))
//                .cornerRadius(20)
//            }
//            .frame(width: 370)
//        }
//    }
//}
//
//#Preview {
//    UserSettingsView()
//}
//
//

import SwiftUI

// MARK: - Model Enums
enum Gender: String, CaseIterable {
    case male = "Мужской"
    case female = "Женский"
    case other = "Другое"
}

enum RelationshipGoal: String, CaseIterable {
    case newExperience = "Новый опыт"
    case friendship = "Дружба"
    case flirt = "Флирт"
}

// MARK: - Social Link Model
struct SocialLink: Identifiable {
    let id = UUID()
    let platform: String
    let url: String
}

// MARK: - User Profile Model
struct UserProfile {
    let name: String
    let age: Int
    let gender: Gender
    let goal: RelationshipGoal
    let bio: String
    let interests: [String]
    let socialLinks: [SocialLink]
    let photoName: String
}

// MARK: - Sample Data
let sampleProfile = UserProfile(
    name: "Марина",
    age: 20,
    gender: .female,
    goal: .newExperience,
    bio: "Люблю активный отдых, горы и хорошие фильмы.",
    interests: ["Активный отдых", "Кино и сериалы", "Горы", "Прогулки"],
    socialLinks: [
        SocialLink(platform: "VK", url: "vk.com/marina1"),
        SocialLink(platform: "Instagram", url: "https://www.instagram.com/i_mish_a"),
        SocialLink(platform: "Telegram", url: "https://t.me/Murtazaev_Av")
    ],
    photoName: "person.crop.circle"
)

// MARK: - Profile Card View
struct DatingProfileView: View {
    let profile: UserProfile
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: profile.photoName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding(.top)
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("\(profile.name), \(profile.age)")
                        .font(.title)
                        .bold()
                }
                
                Text(profile.bio)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    infoRow(title: "Пол", value: profile.gender.rawValue)
                    infoRow(title: "Интересы", value: profile.interests.joined(separator: ", "))
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Социальные сети")
                        .font(.headline)
                        .padding(.horizontal)
                    // MARK: - Social Links
                    linkButtons
                    
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .bold()
            Text(value)
        }
    }
    
    private var invertedLabelBackground: Color {
        colorScheme == .dark ? .white : .black
    }


    var telegramLinkButton: some View {
            Button(action: {
                if let url = URL(string: "tg://resolve?domain=Murtazaev_Av") {
                    UIApplication.shared.open(url, options: [:]) { success in
                        if !success {
                            // fallback на веб-ссылку
                            if let fallbackUrl = URL(string: "https://t.me/Murtazaev_Av") {
                                UIApplication.shared.open(fallbackUrl)
                            }
                        }
                    }
                }
            }) {
                Image("telegram")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(.white)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(.label).opacity(0.7), lineWidth: 2)
                    )
            }
        }

        var instagramLinkButton: some View {
            Button(action: {
                if let url = URL(string: "instagram://user?username=i_mish_a") {
                    UIApplication.shared.open(url, options: [:]) { success in
                        if !success {
                            if let fallbackUrl = URL(string: "https://www.instagram.com/i_mish_a") {
                                UIApplication.shared.open(fallbackUrl)
                            }
                        }
                    }
                }
            }) {
                Image("instagram")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(.white)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(.label).opacity(0.7), lineWidth: 2)
                    )

            }
        }

        var vkLinkButton: some View {
            Button(action: {
                if let url = URL(string: "vk://vk.com/longcherished") {
                    UIApplication.shared.open(url, options: [:]) { success in
                        if !success {
                            if let fallbackUrl = URL(string: "https://vk.com/longcherished") {
                                UIApplication.shared.open(fallbackUrl)
                            }
                        }
                    }
                }
            }) {
                Image("vk")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(.white)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(.label).opacity(0.7), lineWidth: 2)
                    )
            }
        }

        var linkButtons: some View {
            HStack {
                telegramLinkButton.padding(.horizontal, 10)
                Divider()
                instagramLinkButton.padding(.horizontal, 10)
                Divider()
                vkLinkButton.padding(.horizontal, 10)
            }
        }
}

//private func imageForPlatform(_ platform: String) -> Image {
//        switch platform {
//        case "VK": return             Image("telegram") // или "Image("paperplane.circle")", если у тебя кастомная иконка
//        case "Instagram": return Image(systemName: "camera.circle")
//        case "Telegram": return Image(systemName: "paperplane.circle")
//        default: return Image(systemName: "link.circle")
//        }
//    }
//

 //MARK: - Preview
struct DatingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DatingProfileView(profile: sampleProfile)
    }
}
