import Foundation

enum MessageRole: String {
    case user
    case assistant
    case system
}

enum CopilotCard: Equatable {
    case insight(title: String, description: String)
    case recommendation(title: String, description: String, actionTitle: String)
    case alert(title: String, description: String, actionTitle: String)
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let role: MessageRole
    let content: String
    let timestamp: Date
    let card: CopilotCard?
    
    init(role: MessageRole, content: String, timestamp: Date = Date(), card: CopilotCard? = nil) {
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.card = card
    }
}

struct CopilotSuggestion: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let iconName: String?
}
