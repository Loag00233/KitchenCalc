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
    let koefficient: Double
    let isWeight: Bool
    
    init(id: String = UUID().uuidString, title: String, koefficient: Double, isWeight: Bool) {
        self.id = id
        self.title = title
        self.koefficient = koefficient
        self.isWeight = isWeight
    }
    
    static var mockData: [Measure] = [
        Measure(title: "Kg", koefficient: 1, isWeight: true),
        Measure(title: "Gr", koefficient: 0.001, isWeight: true),
        Measure(title: "L", koefficient: 0.001, isWeight: false),
        Measure(title: "Cup (250 ml)", koefficient: 0.00025, isWeight: false),
        Measure(title: "TeaSpoon (5 ml)", koefficient: 0.000005, isWeight: false),
        Measure(title: "Spoon (15 ml)", koefficient: 0.000015, isWeight: false),
    ]
    
    
}
