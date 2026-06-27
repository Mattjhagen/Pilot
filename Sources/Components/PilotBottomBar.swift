import SwiftUI

struct PilotBottomBarItem: Equatable {
    let title: String
    let iconName: String
}

struct PilotBottomBar: View {
    var items: [PilotBottomBarItem]
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack {
            ForEach(0..<items.count, id: \.self) { index in
                Spacer()
                
                Button(action: {
                    withAnimation(AnimationSystem.fastSpring) {
                        selectedIndex = index
                        HapticsManager.shared.selection()
                    }
                }) {
                    VStack(spacing: Spacing.xs) {
                        PilotIcon(name: items[index].iconName, weight: selectedIndex == index ? .semibold : .regular)
                            .font(.system(size: 24))
                        
                        Text(items[index].title)
                            .font(.pilotFootnote)
                    }
                    .foregroundColor(selectedIndex == index ? .pilotAccent : .pilotSecondaryText)
                }
                
                Spacer()
            }
        }
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.md) // Account for safe area roughly if not inside safe area natively
        .background(
            GlassView(cornerRadius: 0)
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(
            VStack {
                Divider().background(Color.pilotPrimaryText.opacity(0.1))
                Spacer()
            }
        )
    }
}
