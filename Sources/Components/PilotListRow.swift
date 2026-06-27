import SwiftUI

struct PilotListRow<TrailingContent: View>: View {
    var iconName: String?
    var title: String
    var subtitle: String?
    var trailingContent: TrailingContent
    
    init(
        iconName: String? = nil,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailingContent: () -> TrailingContent = { EmptyView() }
    ) {
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
        self.trailingContent = trailingContent()
    }
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            if let iconName = iconName {
                PilotIcon(name: iconName, weight: .medium)
                    .foregroundColor(.pilotAccent)
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .pilotTypography(.pilotBody)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                }
            }
            
            Spacer()
            
            trailingContent
        }
        .padding(.vertical, Spacing.sm)
        .contentShape(Rectangle())
    }
}
