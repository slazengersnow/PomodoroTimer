import Foundation
import Combine

final class TimerManager: ObservableObject {
    @Published var mode: TimerMode = .focus
    @Published var phase: TimerPhase = .ready
    @Published var preset: TimerPreset = .standard
    @Published var remainingTime: TimeInterval = 25 * 60
    @Published var completedSessions: Int = 0

    // Custom durations per mode (overrides preset when set)
    @Published var customDurations: [TimerMode: TimeInterval] = [:]

    var statisticsStore: StatisticsStore?

    var totalDuration: TimeInterval {
        customDurations[mode] ?? preset.duration(for: mode)
    }

    var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return 1.0 - (remainingTime / totalDuration)
    }

    private var timer: Timer?
    private var targetDate: Date?
    private var pausedRemaining: TimeInterval?

    private let stepInterval: TimeInterval = 60 // 1分刻み
    private let minDuration: TimeInterval = 60   // 最小1分
    private let maxDuration: TimeInterval = 120 * 60 // 最大120分

    func adjustDuration(by delta: TimeInterval) {
        guard phase == .ready else { return }
        let current = totalDuration
        let newDuration = min(max(current + delta * stepInterval, minDuration), maxDuration)
        customDurations[mode] = newDuration
        remainingTime = newDuration
    }

    func start() {
        guard phase == .ready || phase == .paused || phase == .completed else { return }

        if phase == .completed || phase == .ready {
            remainingTime = totalDuration
        }

        targetDate = Date().addingTimeInterval(remainingTime)
        phase = .running
        startTicking()
    }

    func pause() {
        guard phase == .running else { return }
        pausedRemaining = remainingTime
        phase = .paused
        stopTicking()
    }

    func reset() {
        stopTicking()
        phase = .ready
        remainingTime = totalDuration
        targetDate = nil
        pausedRemaining = nil
    }

    func skip() {
        stopTicking()
        advanceToNextMode()
    }

    func selectMode(_ newMode: TimerMode) {
        stopTicking()
        mode = newMode
        phase = .ready
        remainingTime = customDurations[newMode] ?? preset.duration(for: newMode)
        targetDate = nil
        pausedRemaining = nil
    }

    func selectPreset(_ newPreset: TimerPreset) {
        stopTicking()
        preset = newPreset
        customDurations.removeAll()
        phase = .ready
        remainingTime = newPreset.duration(for: mode)
        targetDate = nil
        pausedRemaining = nil
    }

    private func startTicking() {
        stopTicking()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopTicking() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        guard let targetDate = targetDate else { return }
        let remaining = targetDate.timeIntervalSinceNow
        if remaining <= 0 {
            remainingTime = 0
            completeCurrentSession()
        } else {
            remainingTime = remaining
        }
    }

    private func completeCurrentSession() {
        stopTicking()
        phase = .completed

        if mode.isFocus {
            completedSessions += 1
            let record = SessionRecord(
                duration: totalDuration,
                mode: mode,
                preset: preset
            )
            statisticsStore?.addRecord(record)
        }

        SoundManager.shared.playCompletionSound()
        advanceToNextMode()
    }

    private func advanceToNextMode() {
        switch mode {
        case .focus:
            if completedSessions > 0 && completedSessions % Constants.sessionsBeforeLongBreak == 0 {
                selectMode(.longBreak)
            } else {
                selectMode(.shortBreak)
            }
        case .shortBreak, .longBreak:
            selectMode(.focus)
        }
    }
}
