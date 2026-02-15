import Foundation

struct SessionRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let duration: TimeInterval
    let mode: TimerMode
    let preset: String

    init(date: Date = Date(), duration: TimeInterval, mode: TimerMode, preset: TimerPreset) {
        self.id = UUID()
        self.date = date
        self.duration = duration
        self.mode = mode
        self.preset = preset.rawValue
    }
}
