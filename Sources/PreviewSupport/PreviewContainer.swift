import SwiftUI
import SwiftData

struct PreviewContainer<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .environment(AppState())
            .environment(DependencyContainer.mock)
            .modelContainer(for: [], inMemory: true)
    }
}
