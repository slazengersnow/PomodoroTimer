import SwiftUI

struct TimerControlsView: View {
    @ObservedObject var timerManager: TimerManager

    var body: some View {
        HStack(spacing: 16) {
            // Reset
            Button(action: { timerManager.reset() }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(timerManager.phase == .ready)
            .opacity(timerManager.phase == .ready ? 0.4 : 1.0)

            // Start / Pause
            Button(action: {
                switch timerManager.phase {
                case .ready, .paused, .completed:
                    timerManager.start()
                case .running:
                    timerManager.pause()
                }
            }) {
                Image(systemName: timerManager.phase == .running ? "pause.fill" : "play.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        LinearGradient(
                            colors: timerManager.mode.isBreak
                                ? [.breakGreen, .breakGreenDark]
                                : [.accentBlue, .accentBlueDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            // Skip
            Button(action: { timerManager.skip() }) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
}
