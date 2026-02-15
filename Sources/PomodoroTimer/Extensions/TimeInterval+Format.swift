import Foundation

extension TimeInterval {
    var timerFormatted: String {
        let totalSeconds = Int(max(self, 0))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var shortFormatted: String {
        let totalSeconds = Int(max(self, 0))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        if minutes > 0 {
            return seconds > 0 ? "\(minutes)分\(seconds)秒" : "\(minutes)分"
        }
        return "\(seconds)秒"
    }

    var hoursFormatted: String {
        let hours = self / 3600
        if hours >= 1 {
            return String(format: "%.1f時間", hours)
        }
        return "\(Int(self / 60))分"
    }
}
