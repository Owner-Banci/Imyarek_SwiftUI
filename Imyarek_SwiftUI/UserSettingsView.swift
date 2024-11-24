import SwiftUI

struct UserSettingsView: View {
    
    @State private var userSelectedAge: userAge?
    @State private var userSelectedGender: userGender?
    @State private var interlocutorSelectedAge: userAge?
    @State private var interlocutorSelectedGender: userGender?
    @State private var nicknameTextField: String = ""
    @State private var descriptionTextField: String = ""
    
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
    
    var body: some View {
        VStack {
            HStack {
                settingsCancelButton
                Spacer()
                settingsSaveButton
            }
            ScrollView {
                profileImage
                profileImageChangeButton
                    .padding(.bottom, 25)
                
                nicknameChangeSection
                randomNicknameButton
                    .padding(.bottom, 25)
                
                userDescriptionChangeSection
                    .padding(.bottom, 25)
                
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
                
                quickSettingsButton(
                    title: "Любимая настройка:",
                    subtitle: "Ниже указана самая часто используемая настройка."
                )
                .padding(.bottom, 15)
                
                quickSettingsButton(
                    title: "Предыдущая настройка:",
                    subtitle: "Ниже указаны ваши предыдущие настройки."
                )
                Spacer()
            }
        }
        .background(Color.indigo)
    }
    
    var settingsSaveButton: some View {
        Button(action: {}) {
            Text("Сохранить")
                .padding(.trailing, 30)
                .padding(.top, 22)
        }
    }
    
    var settingsCancelButton: some View {
        Button(action: {}) {
            Text("Отменить")
                .padding(.horizontal, 30)
                .padding(.top, 22)
        }
    }
    
    var profileImage: some View {
        Image(systemName: "swift")
            .resizable()
            .frame(width: 130, height: 130)
            .background(Color.blue)
            .cornerRadius(65)
            .padding(.top, 20)
    }
    
    var profileImageChangeButton: some View {
        Button(action: {}) {
            Text("Изменить фотографию")
                .font(.body)
        }
    }
    
    var nicknameChangeSection: some View {
        VStack(alignment: .leading) {
            Text("Никнейм")
                .font(.system(size: 16, weight: .regular))
            Text("Никнейм будет отображён в чате")
                .font(.system(size: 12, weight: .thin))
            
            TextField("Введите никнейм...", text: $nicknameTextField)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(2)
                .background(Color.black)
                .cornerRadius(10)
                .frame(width: 370)
        }
        .padding(.horizontal, 25)
    }
    
    var randomNicknameButton: some View {
        Button(action: {}) {
            Text("СЛУЧАЙНЫЙ НИКНЕЙМ")
                .font(.body)
                .padding(.vertical, 10)
        }
        .padding(7)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(10)
        .frame(width: 370)
    }
    
    var userDescriptionChangeSection: some View {
        VStack(alignment: .leading) {
            Text("О себе")
                .font(.system(size: 16, weight: .regular))
            Text("Напиши пару слов о себе, чтобы заинтересовать собеседника")
                .font(.system(size: 12, weight: .thin))
            
            TextField("О себе", text: $descriptionTextField)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(2)
                .background(Color.black)
                .cornerRadius(10)
                .frame(width: 370)
        }
        .padding(.horizontal, 25)
    }
    
    func userFilterSettingsView(
        title: String,
        description: String,
        gender: Binding<userGender?>,
        age: Binding<userAge?>
    ) -> some View {
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.system(size: 16, weight: .regular))
                .padding(.horizontal, 25)
            Text(description)
                .font(.system(size: 12, weight: .thin))
                .padding(.horizontal, 25)
            
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
                        .foregroundColor(.white)
                    Text("Укажите свой возраст")
                        .foregroundColor(.white)
                }
                .tint(.white)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
            }
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
            .padding(.horizontal, 25)
            .frame(width: 420, height: 90)
        }
        .frame(maxWidth: 360, maxHeight: 350)
        .padding(.horizontal, 20)
    }
    
    func quickSettingsButton(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 16, weight: .regular))
                .padding(.horizontal, 2)
            Text(subtitle)
                .font(.system(size: 12, weight: .thin))
                .padding(.horizontal, 2)
            
            Button(action: {}) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Свой: Пол: $пол, возраст: $возраст")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Собеседника: $пол, возраст: $возраст")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black)
                .cornerRadius(10)
            }
            .frame(width: 370)
        }
    }
}

#Preview {
    UserSettingsView()
}


