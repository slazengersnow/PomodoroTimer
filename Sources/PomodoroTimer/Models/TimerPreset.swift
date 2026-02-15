import Foundation

enum TimerPreset: String, CaseIterable, Identifiable {
    case standard = "スタンダード"
    case deepFocus = "ディープフォーカス"

    var id: String { rawValue }

    var focusDuration: TimeInterval {
        switch self {
        case .standard: return 25 * 60
        case .deepFocus: return 50 * 60
        }
    }

    var shortBreakDuration: TimeInterval {
        switch self {
        case .standard: return 5 * 60
        case .deepFocus: return 10 * 60
        }
    }

    var longBreakDuration: TimeInterval {
        switch self {
        case .standard: return 15 * 60
        case .deepFocus: return 30 * 60
        }
    }

    func duration(for mode: TimerMode) -> TimeInterval {
        switch mode {
        case .focus: return focusDuration
        case .shortBreak: return shortBreakDuration
        case .longBreak: return longBreakDuration
        }
    }
}
