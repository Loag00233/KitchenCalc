//
//  Badge.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 29.03.2026.
//

import Foundation
import SwiftUI

extension Ingredient.DensityConfidence {
    var badge: some View {
        Text(label)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(colorBadge)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(colorBadge.opacity(0.12),
                        in: Capsule())
    }
}

