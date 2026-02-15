import SwiftUI

extension Color {
    // Background (transparent for frost glass)
    static let backgroundPrimary = Color.clear
    static let backgroundSecondary = Color.white.opacity(0.06)
    static let backgroundTertiary = Color.white.opacity(0.1)

    // Accent
    static let accentBlue = Color(red: 0.25, green: 0.55, blue: 1.0)
    static let accentBlueDark = Color(red: 0.15, green: 0.35, blue: 0.8)
    static let accentGreen = Color(red: 0.2, green: 0.78, blue: 0.55)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.25)

    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.65)
    static let textTertiary = Color(white: 0.45)

    // Ring gradient
    static let ringGradientStart = Color(red: 0.3, green: 0.6, blue: 1.0)
    static let ringGradientEnd = Color(red: 0.15, green: 0.35, blue: 0.85)

    // Break colors
    static let breakGreen = Color(red: 0.2, green: 0.78, blue: 0.55)
    static let breakGreenDark = Color(red: 0.1, green: 0.5, blue: 0.35)
}
