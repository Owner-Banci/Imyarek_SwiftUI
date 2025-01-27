import SwiftUI

struct MainView1: View {
    @State private var navigateToSecondView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Это главный экран")
                    .font(.largeTitle)
                    .padding()
                
                Button(action: {
                    navigateToSecondView = true
                }) {
                    Text("Перейти на другой экран")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .navigationDestination(isPresented: $navigateToSecondView) {
                    SecondView()
                }
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Text("Это второй экран")
                .font(.largeTitle)
                .padding()
        }
    }
}

