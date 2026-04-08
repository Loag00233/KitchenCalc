//
//  Theme.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 24.03.2026.
//

import SwiftUI

extension Color {
    
    static let textPrimary = Color.black.opacity(0.82)
    static let textSecondary = Color.black.opacity(0.42)
    static let textTertiary = Color.black.opacity(0.28)
    
    static let accent = Color.accentColor
    
    // Градиент фона
    static let appBackground = LinearGradient(
            colors: [
                Color("gradientTop"),
                Color("gradientMid"),
                Color("gradientBottom")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
}

extension Font {
    static let viewTitle = Font.system(size: 17, weight: .semibold)
    static let converterValue = Font.system(size: 40, weight: .light)
    static let sectionHeader = Font.system(size: 13, weight: .semibold)
    static let bodyRegular = Font.system(size: 15)
    static let arrowRight = Font.system(size: 13)
}

extension View {
      func hideKeyboardOnTap() -> some View {
          onTapGesture {
              UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
          }
      }
  }

enum Spacing {
    static let extraSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
}

enum Radius {
    static let card: CGFloat = 20
}

struct TextFieldMod: ViewModifier {
    var isInvalid: Bool = false

    func body(content: Content) -> some View {
        content
            .padding(Spacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .stroke(isInvalid ? Color.red : Color.clear)
            )
    }
}

struct ButtonMod: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(Font.bodyRegular)
            .foregroundStyle(color)
            .padding(.vertical, Spacing.large)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
            .contentShape(RoundedRectangle(cornerRadius: Radius.card))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .stroke(color.opacity(0.4), lineWidth: 1)
            )
    }
}

struct KeyboardOk: ViewModifier {
    func body(content: Content) -> some View {
        content
            .submitLabel(.done)
            .onSubmit {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("OK") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
    }
}
