import SwiftUI

enum Theme {
    static let accent = Color(red: 0.55,0.40,0.65)
    static let accent2 = Color(red: 0.85,0.68,0.42)
    static let background = Color(red: 0.07,0.06,0.09)

    static let largeTitle = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let headline = Font.system(.headline, design: .rounded)
    static let body = Font.system(.body, design: .default)
    static let caption = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 14
}
