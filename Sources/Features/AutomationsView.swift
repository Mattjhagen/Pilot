import SwiftUI

struct AutomationsView: View {
    @Environment(Router<AutomationsRoute>.self) private var router
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView { 
                    AutomationsOverviewView() 
                } detail: { 
                    detailPlaceholder 
                }
            } else {
                NavigationStack(path: Bindable(router).path) { 
                    AutomationsOverviewView() 
                }
            }
        }
    }
    
    @ViewBuilder
    private var detailPlaceholder: some View {
        Text("Select an automation to edit")
            .pilotTypography(.pilotBody, color: .pilotSecondaryText)
    }
}
