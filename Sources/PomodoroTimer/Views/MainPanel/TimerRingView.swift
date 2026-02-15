import SwiftUI

struct TimerRingView: View {
    @ObservedObject var timerManager: TimerManager

    private var ringColors: (start: Color, end: Color) {
        if timerManager.mode.isBreak {
            return (.breakGreen, .breakGreenDark)
        }
        return (.ringGradientStart, .ringGradientEnd)
    }

    private var isEditable: Bool {
        timerManager.phase == .ready
    }

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: Constants.timerRingLineWidth)

            // Progress
            Circle()
                .trim(from: 0, to: timerManager.progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [ringColors.start, ringColors.end]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(
                        lineWidth: Constants.timerRingLineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.25), value: timerManager.progress)

            // Center content
            VStack(spacing: 2) {
                Text(timerManager.mode.displayName)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.textSecondary)

                Text(timerManager.remainingTime.timerFormatted)
                    .font(.system(size: 36, weight: .light, design: .monospaced))
                    .foregroundColor(.textPrimary)
            }

            // +/- buttons on left and right sides of ring
            if isEditable {
                HStack {
                    adjustButton(systemName: "minus", delta: -1)
                    Spacer()
                    adjustButton(systemName: "plus", delta: 1)
                }
                .padding(.horizontal, 6)
            }
        }
        .frame(width: Constants.timerRingSize, height: Constants.timerRingSize)
    }

    private func adjustButton(systemName: String, delta: TimeInterval) -> some View {
        Button {
            timerManager.adjustDuration(by: delta)
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.textPrimary)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
