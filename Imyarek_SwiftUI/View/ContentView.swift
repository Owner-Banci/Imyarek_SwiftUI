import SwiftUI

struct ContentView: View {
    
    @State private var userInput: String = ""
    @State private var settingElements = Array(arrayLiteral:
                                                "Настройки 1",
                                               "Настройки 2",
                                               "Настройки 3",
                                               "Настройки 4")
    
    @State private var navigateToSecondView = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer() // Отодвигает кнопку вправо
                    profileEditButton
                    
                }
                profileImage
                profileName
                profileGender
                profileDescriptionEditButton
                promoButton
                profileSettingsList
                Spacer() // Чтобы кнопка оставалась сверху
                
                
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
                    .padding(.trailing, 40) // Отступ от края
            }
            
        )
        .navigationDestination(isPresented: $navigateToSecondView) {
            UserSettingsView()
        }
    }
    
    var profileImage: some View {
        Image(systemName: "swift")
            .resizable()
            .frame(width: 130, height: 130)
            .background(Color.blue)
            .cornerRadius(65)
    }
    
    var profileName: some View {
        Text("Никнейм")
            .font(.title)
    }
    
    var profileGender: some View {
        Text("Пол")
            .font(.title2)
    }
    
    var profileDescriptionEditButton: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 4) {
                Text("О себе")
                    .padding(.bottom, 2) // Отступ только внизу
                Text("Тут должно быть описание пользователя")
                    .font(.subheadline)
                    .foregroundColor(.gray) // Можно сделать текст описания другим цветом
            }
            .padding(10) // Общие отступы внутри кнопки
            .frame(maxWidth: .infinity, alignment: .leading) // Растягиваем текст в ширину
            .background(Color.black) // Фон кнопки
            .cornerRadius(10) // Закругляем углы
        }
        .frame(width: 370) // Фиксируем ширину кнопки
    }
    
    var promoButton: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Премиум-подписка")
                        .foregroundColor(.white)
                        .font(.system(size: 21, weight: .bold))
                    Spacer()
                    Image(systemName: "swift")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                // Индивидуальные плюсы подписки
                Text("• Возможность искать")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                Text("• Ускоренный поиск собеседника")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                Text("• Возможность звонить собеседникам")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
            .padding() // Общий отступ внутри кнопки
            .background(Color.purple) // Фон кнопки
            .cornerRadius(10) // Закруглённые углы
            .frame(width: 370) // Фиксированная ширина кнопки
        }
    }

    var profileSettingsList: some View {
            // Обёртка для списка с закруглёнными краями
            VStack {
                List {
                    ForEach(settingElements, id: \.self) { element in
                        HStack {
                            Image(systemName: "circle")
                            Text(element)
                                .foregroundColor(.white)
                        }
                        .padding(7)
                    }
                    .listRowBackground(Color(.systemIndigo)) // Цвет строки списка
                }
                .listStyle(.plain) // Убираем стандартные стили
                .scrollContentBackground(.hidden) // Убираем фон по умолчанию
            }
            .background(Color(.systemIndigo)) // Цвет заднего фона списка
            .frame(width: 370, height: CGFloat(settingElements.count) * 45) // Высота строки * количество строк
            .cornerRadius(10)
        }
    }





#Preview {
    ContentView()
}
