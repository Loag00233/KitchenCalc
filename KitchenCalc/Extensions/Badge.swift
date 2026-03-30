//
//  Badge.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 29.03.2026.
//

import Foundation
import SwiftUI

extension Ingredient {
    var badge: some View {
        Text(confidence.label)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(confidence.colorBadge)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(confidence.colorBadge.opacity(0.12),
                        in: Capsule())
    }
}

