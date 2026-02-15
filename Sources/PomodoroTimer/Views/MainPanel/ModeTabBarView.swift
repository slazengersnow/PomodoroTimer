import SwiftUI

struct ModeTabBarView: View {
    @ObservedObject var timerManager: TimerManager

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TimerMode.allCases, id: \.self) { mode in
                Button(action: { timerManager.selectMode(mode) }) {
                    Text(mode.displayName)
                        .font(.system(size: 11, weight: timerManager.mode == mode ? .semibold : .regular))
                        .foregroundColor(timerManager.mode == mode ? .textPrimary : .textTertiary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(
                            timerManager.mode == mode
                                ? Color.white.opacity(0.12)
                                : Color.clear
                        )
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
        .padding(.horizontal, 14)
    }
}
