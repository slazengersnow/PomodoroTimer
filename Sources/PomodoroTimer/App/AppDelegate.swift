import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var mainWindow: NSWindow?
    private var menuBarController: MenuBarController?
    private var floatingOverlayWindow: FloatingOverlayWindow?
    private let timerManager = TimerManager()
    private let statisticsStore = StatisticsStore()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        timerManager.statisticsStore = statisticsStore
        menuBarController = MenuBarController(timerManager: timerManager, onTogglePanel: { [weak self] in
            self?.toggleMainPanel()
        })
        setupMainWindow()
        showMainPanel()
    }

    private func setupMainWindow() {
        let contentView = MainPanelView(timerManager: timerManager, statisticsStore: statisticsStore)
        let hostingView = NSHostingView(rootView: contentView)

        let window = DesktopWindow(
            contentRect: NSRect(x: 0, y: 0, width: Constants.mainWindowWidth, height: Constants.mainWindowHeight),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        // Frost glass effect using NSVisualEffectView
        let visualEffect = NSVisualEffectView()
        visualEffect.material = .hudWindow
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = Constants.windowCornerRadius
        visualEffect.layer?.masksToBounds = true

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: visualEffect.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: visualEffect.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: visualEffect.trailingAnchor),
        ])

        window.contentView = visualEffect
        window.backgroundColor = .clear
        window.isOpaque = false
        window.isReleasedWhenClosed = false
        window.isMovableByWindowBackground = false
        window.hasShadow = true
        window.hidesOnDeactivate = false
        window.level = NSWindow.Level(Int(CGWindowLevelForKey(.normalWindow)) - 1)
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]

        // Position bottom-right of screen
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let origin = NSPoint(
                x: screenFrame.maxX - Constants.mainWindowWidth - 20,
                y: screenFrame.minY + 20
            )
            window.setFrameOrigin(origin)
        }

        window.delegate = self

        if let cv = window.contentView {
            cv.wantsLayer = true
            cv.layer?.cornerRadius = Constants.windowCornerRadius
            cv.layer?.masksToBounds = true
        }

        window.startObservingWorkspace()
        mainWindow = window
    }

    private func showMainPanel() {
        mainWindow?.orderFrontRegardless()
        floatingOverlayWindow?.orderOut(nil)
    }

    private func toggleMainPanel() {
        if let window = mainWindow, window.isVisible {
            window.orderOut(nil)
        } else {
            showMainPanel()
        }
    }

    private func showFloatingOverlay() {
        if floatingOverlayWindow == nil {
            floatingOverlayWindow = FloatingOverlayWindow(timerManager: timerManager, onTap: { [weak self] in
                self?.showMainPanel()
            })
        }
        floatingOverlayWindow?.orderFront(nil)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            showMainPanel()
        }
        return true
    }
}

extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow, window === mainWindow else { return }
        if timerManager.phase == .running || timerManager.phase == .paused {
            showFloatingOverlay()
        }
    }
}
