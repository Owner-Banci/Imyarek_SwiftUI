import SwiftUI

struct ContentView: View {
    
    @State private var userInput: String = ""
    @State private var userNickName: String = "Sasha"
    @State private var userGender: String = "Kvadrober"
    @State private var userProfileImage: String = "swift"
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
    
    var settingElements: [SettingItem] {
        [
            SettingItem(title: "Настройка 1", action: {
                print("Переход на экран Настройки 1")
            }),
            SettingItem(title: "Настройка 2", action: {
                print("Переход на экран Настройки 2")
            }),
            SettingItem(title: "Настройка 3", action: {
                print("Переход на экран Настройки 3")
            })
        ]
    }
    
    @State private var navigateToSecondView = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    profileEditButton
                    
                }
                
                profileInfo
                profileDescriptionButton
                profileSettingsList
                Spacer()
                
                
            }
        }
    }
    
    var profileEditButton: some View {
        Button(
            action: {
                navigateToSecondView = true
            },
            label: {
                Text("Изменить")
                    .padding(.trailing, 20)
                    .foregroundColor(.red)
            }
            
        )
        .navigationDestination(isPresented: $navigateToSecondView) {
            DatingProfileView(profile: sampleProfile)
        }
    }
    
    
    var profileInfo: some View {
        VStack {
            Image(systemName: userProfileImage)
                .resizable()
                .frame(width: 130, height: 130)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(65)
            
            Text(userNickName)
                .font(.title)
            
            Text(userGender)
                .font(.title2)
        }
    }
    
    
    
    var profileDescriptionButton: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text("О себе")
                .font(.headline)
                .padding(.bottom, 4)
            Text("Тут должно быть описание пользователя")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay( 
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.label).opacity(0.4), lineWidth: 1)
        )
        .padding(.bottom, 10)
        .frame(width: 370)
    }
    
    
    var profileSettingsList: some View {
        VStack {
            List {
                ForEach(settingElements) { item in
                    Button(action: {
                        item.action()
                    }) {
                        HStack {
                            Image(systemName: "circle")
                            Text(item.title)
                                .foregroundColor(Color(.label))
                        }
                        .padding(7)
                    }
                    .listRowBackground(Color(.secondarySystemBackground))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .frame(width: 370, height: CGFloat(settingElements.count) * 45)
        .cornerRadius(10)
    }
}




//
//#Preview {
//    ContentView()
//}
