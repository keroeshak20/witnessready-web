import SwiftUI

enum Theme {
    static let background = Color(red: 251 / 255, green: 246 / 255, blue: 239 / 255)
    static let surface = Color.white
    static let primary = Color(red: 26 / 255, green: 22 / 255, blue: 18 / 255)
    static let secondary = Color(red: 122 / 255, green: 110 / 255, blue: 101 / 255)
    static let accent = Color(red: 184 / 255, green: 142 / 255, blue: 100 / 255)
    static let accentDeep = Color(red: 139 / 255, green: 99 / 255, blue: 60 / 255)
    static let calmGreen = Color(red: 74 / 255, green: 113 / 255, blue: 84 / 255)
    static let divider = Color(red: 224 / 255, green: 213 / 255, blue: 200 / 255)
    static let subtle = Color(red: 242 / 255, green: 236 / 255, blue: 227 / 255)
    static let cardShadow = Color(red: 184 / 255, green: 142 / 255, blue: 100 / 255).opacity(0.10)

    static let screenPadding: CGFloat = 28
    static let cardPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 32
    static let elementSpacing: CGFloat = 16
    static let cardRadius: CGFloat = 16
    static let buttonRadius: CGFloat = 12
}
