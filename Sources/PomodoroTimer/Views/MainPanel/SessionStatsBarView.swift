import SwiftUI

struct SessionStatsBarView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var statisticsStore: StatisticsStore

    var body: some View {
        HStack(spacing: 0) {
            statItem(
                title: "セッション",
                value: "\(statisticsStore.todaySessions)",
                icon: "flame.fill"
            )
            Spacer()
            statItem(
                title: "集中時間",
                value: statisticsStore.todayFocusTime.hoursFormatted,
                icon: "clock.fill"
            )
            Spacer()
            statItem(
                title: "連続日数",
                value: "\(statisticsStore.currentStreak)日",
                icon: "calendar"
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
    }

    private func statItem(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 8))
                    .foregroundColor(.accentBlue)
                Text(title)
                    .font(.system(size: 8))
                    .foregroundColor(.textTertiary)
            }
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.textPrimary)
        }
    }
}
