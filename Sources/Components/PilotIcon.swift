import SwiftUI

struct PilotIcon: View {
    let name: String
    var weight: Font.Weight = .regular
    
    var body: some View {
        Image(systemName: name)
            .fontWeight(weight)
    }
}
