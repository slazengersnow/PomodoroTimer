import AppKit
import SwiftUI

final class FloatingOverlayWindow: NSPanel {
    init(timerManager: TimerManager, onTap: @escaping () -> Void) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: Constants.overlaySize, height: Constants.overlaySize),
            styleMask: [.nonactivatingPanel, .hudWindow],
            backing: .buffered,
            defer: false
        )

        let overlayView = FloatingOverlayView(timerManager: timerManager, onTap: onTap)
        contentView = NSHostingView(rootView: overlayView)

        level = .floating
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        isMovableByWindowBackground = true
        hidesOnDeactivate = false

        // Position at bottom-right
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let origin = NSPoint(
                x: screenFrame.maxX - Constants.overlaySize - 20,
                y: screenFrame.minY + 20
            )
            setFrameOrigin(origin)
        }
    }
}
