import Testing
import Foundation
@testable import Pilot

struct CopilotViewModelTests {
    
    @Test func testSendMessageAppendsAndReplies() async {
        let mockService = CopilotMockService()
        let viewModel = ConversationViewModel(service: mockService)
        
        // Starts with the greeting
        #expect(viewModel.messages.count == 1)
        #expect(viewModel.messages.first?.role == .assistant)
        
        // Send a message
        viewModel.send("Hello AI")
        
        // Immediately appends user message
        #expect(viewModel.messages.count == 2)
        #expect(viewModel.messages.last?.role == .user)
        #expect(viewModel.messages.last?.content == "Hello AI")
        
        // Give time for the mock service to reply
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Assistant should have replied
        #expect(viewModel.messages.count == 3)
        #expect(viewModel.messages.last?.role == .assistant)
    }
}
