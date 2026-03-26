//
//  Measure.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 15.02.2026.
//

import Foundation
import SwiftData

@Model
class Measure: Hashable {
    
    @Attribute(.unique) var id: UUID
    var title: String
    var shortTitle: String
    var koefficient: Double
    var isWeight: Bool
    var isImperial: Bool
    
    init(id: UUID = UUID(),
         title: String,
         shortTitle: String,
         koefficient: Double,
         isWeight: Bool,
         isImperial: Bool = false) {
        self.id = id
        self.title = title
        self.shortTitle = shortTitle
        self.koefficient = koefficient
        self.isWeight = isWeight
        self.isImperial = isImperial
    }
    
    static var mockDataMeasure: [Measure] = [
        // Имперские
        Measure(title: "Ounce", shortTitle: "oz", koefficient: 0.0283495, isWeight: true, isImperial: true),
        Measure(title: "Pound", shortTitle: "lb", koefficient: 0.453592, isWeight: true, isImperial: true),
        Measure(title: "Fluid ounce", shortTitle: "fl oz", koefficient: 0.0000295735, isWeight: false, isImperial: true),
        Measure(title: "Pint", shortTitle: "pt", koefficient: 0.000473176, isWeight: false, isImperial: true),
        // Метрические
        Measure(title: "Kilogram", shortTitle: "kg", koefficient: 1, isWeight: true),
        Measure(title: "Gram", shortTitle: "g", koefficient: 0.001, isWeight: true),
        Measure(title: "Litre", shortTitle: "L", koefficient: 0.001, isWeight: false),
        Measure(title: "Millilitre", shortTitle: "ml", koefficient: 0.000001, isWeight: false),
        Measure(title: "Cup (250 ml)", shortTitle: "cup", koefficient: 0.00025, isWeight: false),
        Measure(title: "Table spoon (15 ml)", shortTitle: "tbsp", koefficient: 0.000015, isWeight: false),
        Measure(title: "Tea spoon (5 ml)", shortTitle: "tsp", koefficient: 0.000005, isWeight: false),
        
    ]
    
    
    static func searchByID(_ id: String) -> Measure? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        return mockDataMeasure.first { $0.id == uuid }
    }
    
    
    
}
