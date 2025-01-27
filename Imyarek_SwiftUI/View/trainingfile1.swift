import SwiftUI

struct ChatView2: View {
    @State private var messages: [String] = [] // Сообщения
    @State private var newMessage: String = "" // Текст нового сообщения
    
    var body: some View {
        VStack {
            ScrollViewReader { geometry in
                ScrollView {
                    VStack {
                        Spacer()
                        
                        // Блок "О собеседнике"
                        aboutUserBlock
                        
                        // Сообщения
                        ForEach(messages.indices, id: \.self) { index in
                            messageBubble(text: messages[index], isCurrentUser: index % 2 == 0)
                                .id(index) // Указываем идентификатор для каждого сообщения
                        }
                    }
                }
                .background(Color.red) // Занимаем всю доступную область
                .onChange(of: messages) { _ in
                    // Прокручиваем до последнего сообщения при изменении массива сообщений
                    withAnimation {
                        geometry.scrollTo(messages.indices.last, anchor: .bottom)
                    }
                }
//tut kod
            }
            
            xuy
        }
    }
    
    var xuy: some View {
        // Поле ввода нового сообщения
        HStack {
            TextField("Написать сообщение...", text: $newMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)

            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    
    // Блок "О собеседнике"
    var aboutUserBlock: some View {
        VStack {
            Text("О собеседнике")
                .font(.headline)
                .padding(.bottom, 4)
            Text("Ищу собеседника для интересного общения!")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.blue.opacity(0.2))
        .cornerRadius(12)
    }
    
    // Всплывающие сообщения
    func messageBubble(text: String, isCurrentUser: Bool) -> some View {
        Text(text)
            .padding()
            .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
            .cornerRadius(8)
            .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
    }

    // Добавить новое сообщение
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        messages.append(newMessage)
        newMessage = ""
    }
}

