import SwiftUI

struct StandardSheet<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.pilotBackground.ignoresSafeArea()
                
                VStack(spacing: Spacing.medium) {
                    content()
                    Spacer()
                }
                .padding(Spacing.large)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
