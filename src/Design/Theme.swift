import SwiftUI

enum Theme {
    // Основные цвета
    static let primaryRed = Color(hex: "#E21A1A")
    static let secondaryRed = Color(hex: "#CC0000")
    static let backgroundGray = Color(hex: "#F5F5F5")
    static let textGray = Color(hex: "#4A4A4A")
    static let dividerGray = Color(hex: "#E8E8E8")
    
    // Размеры отступов
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xlarge: CGFloat = 32
    }
    
    // Скругления углов
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    // Настройки теней
    static let shadowColor = Color.black.opacity(0.1)
    static let shadowRadius: CGFloat = 10
    static let shadowY: CGFloat = 4
    
    // Шрифты
    static let titleFont = Font.system(size: 24, weight: .bold)
    static let subtitleFont = Font.system(size: 18, weight: .semibold)
    static let bodyFont = Font.system(size: 16, weight: .regular)
    static let captionFont = Font.system(size: 14, weight: .regular)
}

// Расширение для работы с HEX-цветами
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Расширение для поддержки тёмной темы
extension Theme {
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "#1C1C1E") : backgroundGray
    }
    
    static func cardBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "#2C2C2E") : .white
    }
    
    static func textColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .white : textGray
    }
}