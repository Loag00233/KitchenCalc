//
//  Measure.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 15.02.2026.
//

import Foundation

struct Measure: Identifiable, Hashable {
    
    let id: String
    let title: String
    let shortTitle: String
    let koefficient: Double
    let isWeight: Bool
    
    init(id: String = UUID().uuidString, title: String, shortTitle: String, koefficient: Double, isWeight: Bool) {
        self.id = id
        self.title = title
        self.shortTitle = shortTitle
        self.koefficient = koefficient
        self.isWeight = isWeight
    }
    
    static var mockData: [Measure] = [
        Measure(title: "Kg", shortTitle: "kg", koefficient: 1, isWeight: true),
        Measure(title: "Gr", shortTitle: "g", koefficient: 0.001, isWeight: true),
        Measure(title: "Litre", shortTitle: "L", koefficient: 0.001, isWeight: false),
        Measure(title: "Cup (250 ml)", shortTitle: "cup", koefficient: 0.00025, isWeight: false),
        Measure(title: "TeaSpoon (5 ml)", shortTitle: "tsp", koefficient: 0.000005, isWeight: false),
        Measure(title: "Spoon (15 ml)", shortTitle: "tbsp", koefficient: 0.000015, isWeight: false),
    ]
    
    
    static func searchByID(_ id: String) -> Measure? { mockData.first { $0.id == id } }
    
}
