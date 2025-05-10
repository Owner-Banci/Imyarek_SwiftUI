import Foundation

struct ChatViewModel {
    var messages: [ChatMessageViewModel]
}

struct ChatMessageViewModel: Identifiable {
    let id: UUID
    let text: String
    let isCurrentUser: Bool
}

protocol ChatPresentationLogic: AnyObject {
    func presentMessages(_ messages: [ChatMessage])
    func presentComplaintResult(_ message: ChatMessage)
}

final class ChatPresenter: ChatPresentationLogic, ObservableObject {
    @Published var viewModel: ChatViewModel = ChatViewModel(messages: [])
    
    func presentMessages(_ messages: [ChatMessage]) {
        let viewMessages = messages.map {
            ChatMessageViewModel(id: $0.id, text: $0.text, isCurrentUser: $0.isCurrentUser)
        }
        DispatchQueue.main.async {
            self.viewModel.messages = viewMessages
        }
    }
    
    func presentComplaintResult(_ message: ChatMessage) {
        let viewMessage = ChatMessageViewModel(id: message.id, text: message.text, isCurrentUser: message.isCurrentUser)
        DispatchQueue.main.async {
            self.viewModel.messages.append(viewMessage)
        }
    }
}
