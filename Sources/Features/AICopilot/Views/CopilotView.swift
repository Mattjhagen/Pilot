import SwiftUI

struct CopilotView: View {
    @State private var viewModel: ConversationViewModel
    @State private var inputText: String = ""
    @State private var showVoiceAlert = false
    
    init() {
        _viewModel = State(initialValue: ConversationViewModel(service: DependencyContainer.shared.copilotService))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.messages) { message in
                            ChatMessageRow(message: message)
                                .id(message.id)
                        }
                        
                        if viewModel.isThinking {
                            HStack {
                                Text("Thinking...")
                                    .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                                    .padding()
                                Spacer()
                            }
                            .id("thinking")
                        }
                        
                        // Bottom padding for suggestions and input
                        Color.clear.frame(height: 100).id("bottom")
                    }
                    .padding(.vertical, Spacing.md)
                }
                .onChange(of: viewModel.messages.count) { _, _ in
                    withAnimation(.spring()) {
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.isThinking) { _, isThinking in
                    if isThinking {
                        withAnimation(.spring()) {
                            proxy.scrollTo("thinking", anchor: .bottom)
                        }
                    }
                }
            }
            
            VStack(spacing: 0) {
                if !viewModel.suggestions.isEmpty {
                    SuggestionsBar(suggestions: viewModel.suggestions) { suggestion in
                        viewModel.selectSuggestion(suggestion)
                    }
                }
                
                InputBar(text: $inputText) {
                    viewModel.send(inputText)
                    inputText = ""
                } onVoice: {
                    showVoiceAlert = true
                }
            }
            .background(Color.pilotBackground)
        }
        .background(Color.pilotBackground.ignoresSafeArea())
        .navigationTitle("Copilot")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Voice Input", isPresented: $showVoiceAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Voice input coming soon in a future phase.")
        }
    }
}
