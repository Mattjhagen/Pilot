import SwiftUI

struct TrustScoreCard: View {
    let score: TrustScore
    @State private var animatedScore: Double = 0
    
    var colorForScore: Color {
        switch score.grade {
        case "Excellent": return .pilotSuccess
        case "Good": return .pilotAccent
        case "Fair": return .pilotWarning
        default: return .pilotError
        }
    }
    
    var body: some View {
        PilotCard {
            VStack(spacing: Spacing.lg) {
                Text("Trust Score")
                    .pilotTypography(.pilotHeadline)
                
                ZStack {
                    Circle()
                        .stroke(Color.pilotPrimaryText.opacity(0.1), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    
                    Circle()
                        .trim(from: 0, to: animatedScore)
                        .stroke(colorForScore, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 1.5, dampingFraction: 0.8), value: animatedScore)
                    
                    VStack(spacing: 4) {
                        Text("\(score.score)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.pilotPrimaryText)
                        
                        Text("out of \(score.maxScore)")
                            .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                    }
                }
                .frame(width: 200, height: 200)
                
                VStack(spacing: Spacing.xs) {
                    Text("Your score is \(score.grade.lowercased()).")
                        .pilotTypography(.pilotBody)
                    
                    if score.trend != 0 {
                        let isPositive = score.trend > 0
                        HStack {
                            PilotIcon(name: isPositive ? "arrow.up.right" : "arrow.down.right")
                            Text("\(abs(score.trend)) points since last month")
                        }
                        .pilotTypography(.pilotFootnote, color: isPositive ? .pilotSuccess : .pilotError)
                    } else {
                        Text("No change since last month")
                            .pilotTypography(.pilotFootnote, color: .pilotSecondaryText)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            animatedScore = Double(score.score) / Double(score.maxScore)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Trust Score, \(score.score) out of \(score.maxScore), \(score.grade). \(score.trend != 0 ? "Changed by \(score.trend) points since last month" : "No change since last month").")
    }
}
