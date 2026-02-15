// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PomodoroTimer",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "PomodoroTimer",
            path: "Sources/PomodoroTimer",
            swiftSettings: [.swiftLanguageMode(.v5)]
        )
    ]
)
