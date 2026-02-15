import SwiftUI

struct MainPanelView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var statisticsStore: StatisticsStore
    @State private var currentPage = 0

    var body: some View {
        VStack(spacing: 0) {
            if currentPage == 0 {
                timerPage
            } else {
                StatisticsView(statisticsStore: statisticsStore)
            }

            Spacer(minLength: 0)

            // Page dots + mode bar
            VStack(spacing: 8) {
                PageDotsView(pageCount: 2, currentPage: $currentPage)

                ModeTabBarView(timerManager: timerManager)
            }
            .padding(.bottom, 12)
        }
        .frame(
            width: Constants.mainWindowWidth,
            height: Constants.mainWindowHeight
        )
    }

    private var timerPage: some View {
        VStack(spacing: 12) {
            // Preset selector
            HStack(spacing: 8) {
                ForEach(TimerPreset.allCases) { preset in
                    Button(action: { timerManager.selectPreset(preset) }) {
                        Text(preset.rawValue)
                            .font(.system(size: 11, weight: timerManager.preset == preset ? .semibold : .regular))
                            .foregroundColor(timerManager.preset == preset ? .accentBlue : .textTertiary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                timerManager.preset == preset
                                    ? Color.accentBlue.opacity(0.15)
                                    : Color.clear
                            )
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 14)

            // Session indicator dots
            HStack(spacing: 5) {
                ForEach(0..<Constants.sessionsBeforeLongBreak, id: \.self) { i in
                    Circle()
                        .fill(i < timerManager.completedSessions % Constants.sessionsBeforeLongBreak
                              ? Color.accentBlue
                              : Color.white.opacity(0.15))
                        .frame(width: 6, height: 6)
                }
            }

            TimerRingView(timerManager: timerManager)

            TimerControlsView(timerManager: timerManager)

            SessionStatsBarView(timerManager: timerManager, statisticsStore: statisticsStore)
                .padding(.horizontal, 14)
        }
    }
}
