//
//   Ingredient.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 15.02.2026.
//

import SwiftData
import Foundation
import SwiftUI

@Model
class Ingredient: Hashable {
    @Attribute(.unique) var id: UUID
    var title: String
    var density: Double
    
    enum DensityConfidence {
        case exact      // жидкости, масло
        case approximate // сахар, соль, рис
        case rough      // мука, кофе, пудра

        var label: LocalizedStringKey {
            switch self {
            case .exact: return "Exact"
            case .approximate: return "≈ Approximate"
            case .rough: return "~ Rough"
            }
        }

        var colorBadge: Color {
            switch self {
            case .exact: return .green
            case .approximate: return .orange
            case .rough: return .red
            }
        }

        var hint: LocalizedStringKey? {
            switch self {
            case .exact: return nil
            case .approximate: return "Density may vary ±5%"
            case .rough: return "Density varies significantly — result is approximate"
            }
        }
    }
    
    var confidence: DensityConfidence {
        switch density {
        case 950...:   return .exact      // вода, молоко, масло, мёд
        case 800..<950: return .approximate // сахар, соль, рис
        default:       return .rough      // мука, кофе и всё сыпучее лёгкое
        }
    }
    
    init(id: UUID = UUID(), title: String, density: Double) {
        self.id = id
        self.title = title
        self.density = density
    }
    
    static let mockData: [Ingredient] = [
        .init(title: String(localized: "ingredient_sugar"), density: 1600),
        .init(title: String(localized: "ingredient_water"), density: 1000),
        .init(title: String(localized: "ingredient_salt"), density: 1100),
        .init(title: String(localized: "ingredient_rice"), density: 750),
        .init(title: String(localized: "ingredient_flour"), density: 600),
        .init(title: String(localized: "ingredient_sunflower_oil"), density: 920)
    ]
    
    
}


// ["Сахар", "Вода", "Гречка", "Соль", "Рис", "Мука", "Масло"]
