import SwiftUI

struct FloatingOverlayView: View {
    @ObservedObject var timerManager: TimerManager
    let onTap: () -> Void

    private var ringColor: Color {
        timerManager.mode.isBreak ? .breakGreen : .accentBlue
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color.backgroundPrimary.opacity(0.85))

            // Progress ring
            Circle()
                .trim(from: 0, to: timerManager.progress)
                .stroke(ringColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .padding(4)

            // Time
            VStack(spacing: 2) {
                Text(timerManager.remainingTime.timerFormatted)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.textPrimary)
                Text(timerManager.mode.displayName)
                    .font(.system(size: 8))
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(width: Constants.overlaySize, height: Constants.overlaySize)
        .onTapGesture {
            onTap()
        }
    }
}
