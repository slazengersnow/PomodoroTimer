import AppKit

final class DesktopWindow: NSPanel {
    private var workspaceObserver: Any?
    private var dragStartLocation: NSPoint?

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override func mouseDown(with event: NSEvent) {
        dragStartLocation = NSEvent.mouseLocation
        super.mouseDown(with: event)
    }

    override func mouseDragged(with event: NSEvent) {
        guard let startLocation = dragStartLocation else { return }
        let current = NSEvent.mouseLocation
        var origin = frame.origin
        origin.x += current.x - startLocation.x
        origin.y += current.y - startLocation.y
        setFrameOrigin(origin)
        dragStartLocation = current
    }

    override func mouseUp(with event: NSEvent) {
        dragStartLocation = nil
        super.mouseUp(with: event)
    }

    func startObservingWorkspace() {
        workspaceObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
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
