////
////  ChatView.swift
////  Imyarek_SwiftUI
////
////  Created by Авазбек on 09.12.2024.
////
//import SwiftUI
//
//
//
//struct ChatView: View {
//    @State private var messages: [String] = [] // Сообщения
//    @State private var newMessage: String = "" // Текст нового сообщения
//    
//    var body: some View {
//        VStack {
//            chatHeader
//            ScrollViewReader { geometry in
//                ScrollView {
//                    VStack {
////                        Spacer()
//                        emptySpace
//                        
//                        // Блок "О собеседнике"
//                        aboutUserBlock
//                        
//                        // Сообщения
//                        ForEach(messages.indices, id: \.self) { index in
//                            messageBubble(text: messages[index], isCurrentUser: index % 2 == 0)
//                                .id(index) // Указываем идентификатор для каждого сообщения
//                        }
//                    }
//                }
////                .background(Color.red) // Занимаем всю доступную область
//                .onChange(of: messages) { _ in
//                    // Прокручиваем до последнего сообщения при изменении массива сообщений
//                    withAnimation {
//                        geometry.scrollTo(messages.indices.last, anchor: .bottom)
//                    }
//                }
////tut kod
//            }
//            
//            chatBottomBar
//        }
//    }
//    
//    
//    var emptySpace: some View {
//        VStack {
//            
//        }
//        .frame(height: 550)
//        .background(Color.black)
//    }
//    
//    
//    var chatHeader: some View {
//        HStack {
//            Text("Nickname")
//                .padding(.horizontal, 30)
//                .padding(.vertical, 8)
//            Spacer()
//            Image(systemName: "exclamationmark.circle.fill")
//                .resizable()
//                .frame(width: 25, height: 25)
//                .padding(.horizontal, 25)
//                .padding(.vertical, 8)
//        }
////        .background(Color.red)
//        
//        
//    }
//    
//    // Блок "О собеседнике"
//    var aboutUserBlock: some View {
//        VStack {
//            Text("О собеседнике")
//                .font(.headline)
//                .padding(.bottom, 4)
//            Text("Ищу собеседника для интересного общения!")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.blue.opacity(0.2))
//        .cornerRadius(12)
//    }
//    
//    var chatBottomBar: some View {
//        HStack {
//            Button(action: {}) {
//                Image(systemName: "calendar")
//            }
//            
//            chatTextField
//            
//            Button(action: sendMessage) {
//                Image(systemName: "paperplane")
//            }
//        }
//        .padding()
//        .background(Color.gray.opacity(0.2))
//    }
//    
//    var chatTextField: some View {
//        HStack {
//            TextField(
//                "...",
//                text: $newMessage
//                )
//            .padding()
//            
//            Button(
//                action: {},
//                label: {
//                    
//                    Image(systemName: "swift")
//                }
//            )
//            .padding()
//        }
//        .background(Color.white)
//        .cornerRadius(10)
//    }
//    
//    // Всплывающие сообщения
//    func messageBubble(text: String, isCurrentUser: Bool) -> some View {
//        Text(text)
//            .padding()
//            .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
//            .cornerRadius(8)
//            .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
//    }
//
//    // Добавить новое сообщение
//    func sendMessage() {
//        guard !newMessage.isEmpty else { return }
//        messages.append(newMessage)
//        newMessage = ""
//    }
//}
//
//#Preview {
//    ChatView()
//}





import SwiftUI

struct ChatView: View {
    @StateObject private var interactor = ChatInteractor()
    @StateObject private var presenter = ChatPresenter()

    @State private var newMessage: String = ""
    @State private var showComplaintDialog = false
    @State private var bottomState: ChatBottomState = .typing


    
    
    var body: some View {
        VStack {
            chatHeader
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 6) {
                        aboutUserBlock
                        ForEach(presenter.viewModel.messages) { msg in
                            messageBubble(text: msg.text,
                                          isCurrentUser: msg.isCurrentUser)
                                .id(msg.id)
                        }


                    }
                    .padding(.vertical, 8)
                }
                .onChange(of: presenter.viewModel.messages.count) { _ in
                    if let last = presenter.viewModel.messages.last {
                        withAnimation(.easeOut(duration: 0.25)) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            chatBottomBar
        }
        .onAppear {
            interactor.presenter = presenter
            Task { await interactor.connectChat() }
        }
        .onDisappear {
            Task { await interactor.disconnectChat() }
        }

    }
    
    var chatHeader: some View {
        HStack {
            Text("Имярек")
                .font(.system(.headline, design: .serif))
            Spacer()
            Button(action: {
                showComplaintDialog = true
            }) {
                Text("Пожаловаться")
                    .foregroundColor(.red)
                    .font(.system(.body, design: .serif))
            }
            .confirmationDialog(
                        "Укажите причину для жалобы",
                        isPresented: $showComplaintDialog,
                        titleVisibility: .visible
                    ) {
                        ForEach(ComplaintReason.allCases, id: \.self) { reason in
                            Button(reason.rawValue) {
                                print("Выбрана причина: \(reason.rawValue)")
                            }
                        }
                        Button("Отмена", role: .cancel) {
                }
                        .font(.system(.body, design: .serif))
                        
            }
        }
        .padding()
    }
    
    // MARK: — Пузырёк сообщения
    func messageBubble(text: String, isCurrentUser: Bool) -> some View {
        HStack {
            if isCurrentUser { Spacer() }
            Text(text)
                .padding(8)
                .background(isCurrentUser
                            ? Color(.darkGray)
                            : Color(.lightGray))
                .foregroundColor(isCurrentUser ? Color(.white)   
                                 : Color(.black).opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
                .cornerRadius(20)
            if !isCurrentUser { Spacer() }
        }
        .padding(.horizontal, 8)
    }
    
    var aboutUserBlock: some View {
        VStack {
            Text("О собеседнике")
                .padding(.bottom, 4)
                .font(.system(.headline, design: .serif))
            Text("Ищу собеседника для интересного общения!")
                .foregroundColor(.gray)
                .font(.system(.subheadline, design: .serif))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2) // мягкая тень
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.label).opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    


    
    
    
    @ViewBuilder
    private var chatBottomBar: some View {
        switch bottomState {
        
        case .typing:
            HStack {
                Button(action: {
                    bottomState = .actions
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(Color(.label).opacity(0.75))
                }
                .padding(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.label).opacity(0.4), lineWidth: 1)
                )
                
                TextField("Введите сообщение...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(20)
                    .font(.system(.body, design: .serif))
                
                Button(action: {
                    Task {
                        await interactor.sendMessage(newMessage)
                        messageBubble(text: newMessage, isCurrentUser: true)
                        newMessage = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color(.label).opacity(0.75))
                    
                }
                .padding(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.label).opacity(0.4), lineWidth: 1)
                )
            }
            .padding(15)
            .background(Color(.secondarySystemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: -1)


            
        case .actions:
            VStack(spacing: 7) {
                HStack {
                    Button(action: {
                        bottomState = .typing
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .foregroundColor(Color(.label).opacity(0.75))
                    }
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.label).opacity(0.4), lineWidth: 1)
                    )
                    
                    TextField("Введите сообщение...", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .cornerRadius(20)
                        .font(.system(.body, design: .serif))
                    
                    Button(action: {
                        Task {
                            await interactor.sendMessage(newMessage)
                            newMessage = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color(.label).opacity(0.75))
                        
                    }
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.label).opacity(0.4), lineWidth: 1)
                    )
                }
                .padding(5)
                .background(Color(.secondarySystemBackground))

                
                Button("Предложить дружбу") {
                }
                .buttonStyle(FilledActionButtonStyle(color: .red))
                .font(.system(.body, design: .serif))
                
                Button("Завершить чат") {
                    bottomState = .ended
                }
                .buttonStyle(FilledActionButtonStyle(color: Color(.secondarySystemBackground)))
                .font(.system(.body, design: .serif))
                
                Button("Новый собеседник") {
                    bottomState = .typing
                }
                .buttonStyle(FilledActionButtonStyle(color: Color(.secondarySystemBackground)))
                .font(.system(.body, design: .serif))
            }
            .padding(15)
            .background(Color(.secondarySystemBackground))
            
        case .ended:
            VStack(spacing: 8) {
                Text("Ваш собеседник завершил чат")
                    .foregroundColor(.secondary)
                    .font(.system(.body, design: .serif))
                
                Button("Пожаловаться") {
                }
                .buttonStyle(FilledActionButtonStyle(color: .red))
                .font(.system(.body, design: .serif))
                
                Button("Завершить чат") {
                }
                .buttonStyle(FilledActionButtonStyle(color: Color(.secondarySystemBackground)))
                .font(.system(.body, design: .serif))
                
                Button("Новый собеседник") {
                    bottomState = .typing
                }
                .buttonStyle(FilledActionButtonStyle(color: Color(.secondarySystemBackground)))
                .font(.system(.body, design: .serif))
            }
            .padding()
        }
    }


}

struct FilledActionButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(color.opacity(configuration.isPressed ? 0.3 : 1))
            .foregroundColor(Color(.label).opacity(0.7))
            .cornerRadius(20)
            .overlay( 
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.label).opacity(0.4), lineWidth: 1)
            )
    }
}




#Preview {
    ChatView()
}
