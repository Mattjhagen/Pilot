import SwiftUI

struct MoneyView: View {
    @Environment(Router<MoneyRoute>.self) private var router
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView { 
                    MoneyOverviewView() 
                } detail: { 
                    detailPlaceholder 
                }
            } else {
                NavigationStack(path: Bindable(router).path) { 
                    MoneyOverviewView() 
                }
            }
        }
    }
    
    @ViewBuilder
    private var detailPlaceholder: some View {
        Text("Select an account or transaction")
            .pilotTypography(.pilotBody, color: .pilotSecondaryText)
    }
}
