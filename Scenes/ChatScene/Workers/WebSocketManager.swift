import Foundation
import Combine

final class WebSocketWorker {
    private var webSocketTask: URLSessionWebSocketTask?
    private let db = DatabaseService.shared
    
    var chatID: String = "chat123"
    var currentUserID: String = "currentUser"
    var remoteUserID: String = "remoteUser"
    
    let incomingMessage = PassthroughSubject<ChatMessage, Never>()
    
    func connect() {
        guard let url = URL(string: "ws://127.0.0.1:8000/ws") else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func sendMessageAsync(_ message: String) async -> ChatMessage {
        let timestamp = Int(Date().timeIntervalSince1970)
        await db.insertMessage(chatID: self.chatID,
                               senderID: self.currentUserID,
                               text: message,
                               timestamp: timestamp)
        let outgoing = ChatMessage(text: message, isCurrentUser: true)
        await withCheckedContinuation { continuation in
            let msg = URLSessionWebSocketTask.Message.string(message)
            webSocketTask?.send(msg) { error in
                if let error = error {
                    print("Ошибка отправки: \(error)")
                }
                continuation.resume()
            }
        }
        return outgoing
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(.string(let text)):
                let timestamp = Int(Date().timeIntervalSince1970)
                Task {
                    await self.db.insertMessage(chatID: self.chatID,
                                                senderID: self.remoteUserID,
                                                text: text,
                                                timestamp: timestamp)
                }
                let incoming = ChatMessage(text: text, isCurrentUser: false)
                DispatchQueue.main.async {
                    self.incomingMessage.send(incoming)
                }
            case .failure(let error):
                print("Ошибка получения: \(error)")
            default:
                break
            }
            self.receiveMessage()
        }
    }
}
