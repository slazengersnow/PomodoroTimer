import Foundation

enum TimerMode: String, Codable, CaseIterable {
    case focus = "集中"
    case shortBreak = "小休憩"
    case longBreak = "長休憩"

    var displayName: String { rawValue }

    var isFocus: Bool { self == .focus }
    var isBreak: Bool { self == .shortBreak || self == .longBreak }
}
