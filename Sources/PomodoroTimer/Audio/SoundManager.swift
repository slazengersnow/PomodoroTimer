import AppKit

final class SoundManager {
    static let shared = SoundManager()

    private init() {}

    func playCompletionSound() {
        NSSound(named: "Glass")?.play()
    }
}
