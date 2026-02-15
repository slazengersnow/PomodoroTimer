import AppKit
import Combine
import SwiftUI

final class MenuBarController {
    private var statusItem: NSStatusItem
    private let timerManager: TimerManager
    private let onTogglePanel: () -> Void
    private var cancellables = Set<AnyCancellable>()

    init(timerManager: TimerManager, onTogglePanel: @escaping () -> Void) {
        self.timerManager = timerManager
        self.onTogglePanel = onTogglePanel

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "Pomodoro Timer")
            button.action = #selector(statusBarButtonClicked(_:))
            button.target = self
        }

        timerManager.$remainingTime
            .combineLatest(timerManager.$phase)
            .receive(on: RunLoop.main)
            .sink { [weak self] remaining, phase in
                self?.updateDisplay(remaining: remaining, phase: phase)
            }
            .store(in: &cancellables)
    }

    private func updateDisplay(remaining: TimeInterval, phase: TimerPhase) {
        guard let button = statusItem.button else { return }
        if phase == .running || phase == .paused {
            button.title = " \(remaining.timerFormatted)"
        } else {
            button.title = ""
        }
    }

    @objc private func statusBarButtonClicked(_ sender: Any?) {
        onTogglePanel()
    }
}
