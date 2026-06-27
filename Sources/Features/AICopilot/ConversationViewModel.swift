import Foundation
import Observation

@Observable
final class ConversationViewModel {
    private let service: CopilotService
    
    var messages: [ChatMessage] = []
    var suggestions: [CopilotSuggestion] = []
    var isThinking = false
    
    init(service: CopilotService) {
        self.service = service
        
        // Initial assistant greeting
        messages.append(ChatMessage(role: .assistant, content: "Hi! I’m your Copilot. How can I help?"))
        
        Task {
            await loadSuggestions()
        }
    }
    
    @MainActor
    func send(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(role: .user, content: text)
        messages.append(userMessage)
        
        Task {
            await generateMockResponse(for: text)
        }
    }
    
    @MainActor
    func selectSuggestion(_ suggestion: CopilotSuggestion) {
        send(suggestion.title)
    }
    
    @MainActor
    private func generateMockResponse(for query: String) async {
        isThinking = true
        defer { isThinking = false }
        
        do {
            let response = try await service.fetchResponse(for: query)
            messages.append(response)
        } catch {
            print("Failed to fetch response: \(error)")
        }
    }
    
    @MainActor
    private func loadSuggestions() async {
        do {
            suggestions = try await service.fetchSuggestions()
        } catch {
            print("Failed to load suggestions: \(error)")
        }
    }
}
