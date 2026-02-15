import AppKit

final class DesktopWindow: NSPanel {
    private var workspaceObserver: Any?

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override func mouseDown(with event: NSEvent) {
        let locationInWindow = event.locationInWindow
        if let contentView = contentView,
           let hitView = contentView.hitTest(locationInWindow),
           hitView === contentView || hitView is NSVisualEffectView {
            performDrag(with: event)
        } else {
            super.mouseDown(with: event)
        }
    }

    func startObservingWorkspace() {
        workspaceObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            // When any other app activates, send this window behind all others
            if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
               app.bundleIdentifier != Bundle.main.bundleIdentifier {
                self.order(.below, relativeTo: 0)
            }
        }
    }

    deinit {
        if let observer = workspaceObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
        }
    }
}
