import Foundation
import Combine

protocol ChatBusinessLogic {
    func connectChat() async
    func disconnectChat() async
    func sendMessage(_ text: String) async
    func submitComplaint(for message: ChatMessage, reason: String) async
}

final class ChatInteractor: ChatBusinessLogic, ObservableObject {
    @Published var messages: [ChatMessage] = []
    
    private let webSocketWorker: WebSocketWorker
    private var cancellables = Set<AnyCancellable>()
    
    weak var presenter: ChatPresentationLogic?
    
    init(worker: WebSocketWorker = WebSocketWorker()) {
        self.webSocketWorker = worker
        bindWorker()
    }
    
    func connectChat() async {
        webSocketWorker.connect()
    }
    
    func disconnectChat() async {
        webSocketWorker.disconnect()
    }
    
    func sendMessage(_ text: String) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let message = ChatMessage(text: text, isCurrentUser: true)
        
        DispatchQueue.main.async {
            self.messages.append(message)
            self.presenter?.presentMessages(self.messages)
        }
        
        // Параллельно пробуем отправить в сокет
        let _ = await webSocketWorker.sendMessageAsync(text)
    }

    
    func submitComplaint(for message: ChatMessage, reason: String) async {
        let complaintResponse = ChatMessage(text: "Жалоба отправлена: \(reason)", isCurrentUser: false)
        DispatchQueue.main.async {
            self.messages.append(complaintResponse)
            self.presenter?.presentComplaintResult(complaintResponse)
        }
    }
    
    private func bindWorker() {
        webSocketWorker.incomingMessage
            .sink { [weak self] newMessage in
                guard let self = self else { return }
                self.messages.append(newMessage)
                self.presenter?.presentMessages(self.messages)
            }
            .store(in: &cancellables)
    }
}
