import Foundation

protocol CopilotService {
    func fetchResponse(for query: String) async throws -> ChatMessage
    func fetchSuggestions() async throws -> [CopilotSuggestion]
}

final class CopilotMockService: CopilotService {
    
    func fetchResponse(for query: String) async throws -> ChatMessage {
        try await Task.sleep(nanoseconds: 1_500_000_000) // Simulate processing time
        
        let responses: [ChatMessage] = [
            ChatMessage(role: .assistant, content: "You spent 23% less eating out this week.", card: .insight(title: "Great Job!", description: "Dining out expenses are down.")),
            ChatMessage(role: .assistant, content: "Your checking balance will fall below $400 next Thursday.", card: .alert(title: "Low Balance Warning", description: "Upcoming bills will drain your checking account.", actionTitle: "Transfer Funds")),
            ChatMessage(role: .assistant, content: "You can safely invest another $200 this month without impacting your upcoming bills.", card: .recommendation(title: "Investment Opportunity", description: "You have excess cash available.", actionTitle: "Invest Now")),
            ChatMessage(role: .assistant, content: "I analyzed your recent transactions. Everything looks on track based on your typical spending habits.")
        ]
        
        return responses.randomElement()!
    }
    
    func fetchSuggestions() async throws -> [CopilotSuggestion] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [
            CopilotSuggestion(title: "Analyze Spending", subtitle: "This week", iconName: "chart.pie.fill"),
            CopilotSuggestion(title: "Upcoming Bills", subtitle: "Next 7 days", iconName: "calendar"),
            CopilotSuggestion(title: "Save More", subtitle: "Recommendations", iconName: "leaf.fill")
        ]
    }
}
