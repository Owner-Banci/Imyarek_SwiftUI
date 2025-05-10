//import SwiftUI
//
//struct MainView1: View {
//    @State private var navigateToSecondView = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text("Это главный экран")
//                    .font(.largeTitle)
//                    .padding()
//                
//                Button(action: {
//                    navigateToSecondView = true
//                }) {
//                    Text("Перейти на другой экран")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.green)
//                        .cornerRadius(8)
//                }
//                .navigationDestination(isPresented: $navigateToSecondView) {
//                    SecondView()
//                }
//            }
//        }
//    }
//}
//
//struct SecondView: View {
//    var body: some View {
//        VStack {
//            Text("Это второй экран")
//                .font(.largeTitle)
//                .padding()
//        }
//    }
//}
//

import SwiftUI

struct TelegramLinkButton: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            openTelegramLink()
        }) {
            Image("telegram")
                .resizable()
                .frame(width: 60, height: 60)
                .padding()
                .background(invertedLabelBackground)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(.label).opacity(0.7), lineWidth: 2)
                )
        }
    }

    // Инвертированный фон (обратный цвет к label)
    var invertedLabelBackground: Color {
        colorScheme == .dark ? .white : .black
    }

    // Открытие Telegram
    func openTelegramLink() {
        if let url = URL(string: "tg://resolve?domain=Murtazaev_Av") {
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    if let fallbackUrl = URL(string: "https://t.me/Murtazaev_Av") {
                        UIApplication.shared.open(fallbackUrl)
                    }
                }
            }
        }
    }
}



#Preview {
    TelegramLinkButton()
}
