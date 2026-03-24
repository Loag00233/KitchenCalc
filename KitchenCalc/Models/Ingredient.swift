//
//   Ingredient.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 15.02.2026.
//

import Foundation

struct Ingredient: Identifiable, Hashable{
    let id: String //= UUID().uuidString
    let title: String
    let density: Double
    
    init(id: String = UUID().uuidString, title: String, density: Double) {
        self.id = id
        self.title = title
        self.density = density
    }
    
    static let mockData: [Ingredient] = [
        .init(title: "Sugar", density: 1600),
        .init(title: "Water", density: 1000),
        .init(title: "Buckweat", density: 800),
        .init(title: "Salt", density: 1100),
        .init(title: "Rice", density: 750),
        .init(title: "Flour", density: 600),
        .init(title: "Sunflower Oil", density: 920)
    ]
    
    
}


// ["Сахар", "Вода", "Гречка", "Соль", "Рис", "Мука", "Масло"]
