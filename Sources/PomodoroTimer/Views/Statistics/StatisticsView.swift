import SwiftUI

struct StatisticsView: View {
    @ObservedObject var statisticsStore: StatisticsStore

    var body: some View {
        VStack(spacing: 16) {
            Text("統計")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.textPrimary)

            // Stat cards
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatCardView(
                    title: "今日のセッション",
                    value: "\(statisticsStore.todaySessions)",
                    icon: "flame.fill",
                    color: .accentOrange
                )
                StatCardView(
                    title: "今日の集中時間",
                    value: statisticsStore.todayFocusTime.hoursFormatted,
                    icon: "clock.fill",
                    color: .accentBlue
                )
                StatCardView(
                    title: "連続日数",
                    value: "\(statisticsStore.currentStreak)日",
                    icon: "calendar",
                    color: .accentGreen
                )
                StatCardView(
                    title: "合計セッション",
                    value: "\(statisticsStore.totalSessions)",
                    icon: "chart.bar.fill",
                    color: .ringGradientStart
                )
            }
            .padding(.horizontal, 20)

            // Weekly chart
            WeeklyChartView(data: statisticsStore.weeklyData())
                .padding(.horizontal, 20)
        }
    }
}
