import SwiftUI

struct TrustView: View {
    @Environment(Router<TrustRoute>.self) private var router
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView { 
                    TrustOverviewView() 
                } detail: { 
                    detailPlaceholder 
                }
            } else {
                NavigationStack(path: Bindable(router).path) { 
                    TrustOverviewView() 
                }
            }
        }
    }
    
    @ViewBuilder
    private var detailPlaceholder: some View {
        Text("Select a trust metric")
            .pilotTypography(.pilotBody, color: .pilotSecondaryText)
    }
}
