import Foundation

final class StatisticsStore: ObservableObject {
    @Published private(set) var records: [SessionRecord] = []

    private let userDefaultsKey = "pomodoroSessionRecords"
    private let calendar = Calendar.current

    init() {
        loadRecords()
    }

    // MARK: - Computed Properties

    var todaySessions: Int {
        todayRecords.count
    }

    var todayFocusTime: TimeInterval {
        todayRecords.reduce(0) { $0 + $1.duration }
    }

    var totalSessions: Int {
        records.filter { $0.mode == .focus }.count
    }

    var totalFocusTime: TimeInterval {
        records.filter { $0.mode == .focus }.reduce(0) { $0 + $1.duration }
    }

    var currentStreak: Int {
        var streak = 0
        var date = calendar.startOfDay(for: Date())

        // Check if today has sessions
        if records.contains(where: { calendar.isDate($0.date, inSameDayAs: date) && $0.mode == .focus }) {
            streak = 1
            date = calendar.date(byAdding: .day, value: -1, to: date)!
        }

        while records.contains(where: { calendar.isDate($0.date, inSameDayAs: date) && $0.mode == .focus }) {
            streak += 1
            date = calendar.date(byAdding: .day, value: -1, to: date)!
        }

        return streak
    }

    // MARK: - Weekly/Monthly Data

    func weeklyData() -> [(day: String, minutes: Double)] {
        let today = calendar.startOfDay(for: Date())
        let weekdays = ["日", "月", "火", "水", "木", "金", "土"]
        var result: [(day: String, minutes: Double)] = []

        for i in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let weekday = calendar.component(.weekday, from: date) - 1
            let dayRecords = records.filter {
                calendar.isDate($0.date, inSameDayAs: date) && $0.mode == .focus
            }
            let minutes = dayRecords.reduce(0.0) { $0 + $1.duration } / 60.0
            result.append((day: weekdays[weekday], minutes: minutes))
        }

        return result
    }

    // MARK: - Mutation

    func addRecord(_ record: SessionRecord) {
        records.append(record)
        saveRecords()
    }

    // MARK: - Private

    private var todayRecords: [SessionRecord] {
        records.filter { calendar.isDateInToday($0.date) && $0.mode == .focus }
    }

    private func saveRecords() {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    private func loadRecords() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([SessionRecord].self, from: data) else {
            return
        }
        records = decoded
    }
}
