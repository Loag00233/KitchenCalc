//
//  Theme.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 24.03.2026.
//

import SwiftUI

// MARK: - Colors
extension Color {
    
    // Текст
    static let textPrimary = Color.black.opacity(0.82)
    static let textSecondary = Color.black.opacity(0.42)
    static let textTertiary = Color.black.opacity(0.28)
    
    // Акцент (синий из конвертера)
    static let accent = Color.accentColor
    
    // Градиент фона
    static let gradientMint = Color(red: 0.70, green: 0.93, blue: 0.85)
    static let gradientSky = Color(red: 0.55, green: 0.82, blue: 0.95)
    static let gradientBlue = Color(red: 0.22, green: 0.50, blue: 0.85)
    
    // Готовый градиент как ShapeStyle
    static let appBackground = LinearGradient(
        colors: [.gradientMint, .gradientSky, .gradientBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Typography
extension Font {
    static let productTitle = Font.system(size: 17, weight: .semibold)
    static let converterValue = Font.system(size: 40, weight: .light)
    static let sectionHeader = Font.system(size: 13, weight: .semibold)
    static let bodyRegular = Font.system(size: 15)
    static let arrowRight = Font.system(size: 13)
}

// MARK: - Spacing
enum Spacing {
    static let extraSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
}

// MARK: - Radius
enum Radius {
    static let card: CGFloat = 20
}
