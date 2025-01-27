//
//  ChatView.swift
//  Imyarek_SwiftUI
//
//  Created by Авазбек on 09.12.2024.
//
import SwiftUI



struct ChatView: View {
    @State private var messages: [String] = [] // Сообщения
    @State private var newMessage: String = "" // Текст нового сообщения
    
    var body: some View {
        VStack {
            chatHeader
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
//                .background(Color.red) // Занимаем всю доступную область
                .onChange(of: messages) { _ in
                    // Прокручиваем до последнего сообщения при изменении массива сообщений
                    withAnimation {
                        geometry.scrollTo(messages.indices.last, anchor: .bottom)
                    }
                }
//tut kod
            }
            
            chatBottomBar
        }
    }
    
    var chatHeader: some View {
        HStack {
            Text("Nickname")
                .padding(.horizontal, 30)
                .padding(.vertical, 8)
            Spacer()
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(.horizontal, 25)
                .padding(.vertical, 8)
        }
//        .background(Color.red)
        
        
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
    
    var chatBottomBar: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "calendar")
            }
            
            chatTextField
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
    
    var chatTextField: some View {
        HStack {
            TextField(
                "...",
                text: $newMessage
                )
            .padding()
            
            Button(
                action: {},
                label: {
                    
                    Image(systemName: "swift")
                }
            )
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
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

//#Preview {
//    ChatView()
//}
