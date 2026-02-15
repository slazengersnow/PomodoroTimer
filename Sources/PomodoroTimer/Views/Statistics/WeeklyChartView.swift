import SwiftUI

struct WeeklyChartView: View {
    let data: [(day: String, minutes: Double)]

    private var maxMinutes: Double {
        max(data.map(\.minutes).max() ?? 1, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("今週")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textPrimary)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, entry in
                    VStack(spacing: 4) {
                        // Bar
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [.accentBlue, .accentBlueDark],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(
                                height: max(4, CGFloat(entry.minutes / maxMinutes) * 80)
                            )

                        // Label
                        Text(entry.day)
                            .font(.system(size: 10))
                            .foregroundColor(.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 100)
        }
        .padding(12)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}
