//
//  Result.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 19.02.2026.
//

import Foundation
import SwiftData

@Model
class SolveResult: Identifiable {
    var id: UUID
    var inValue: Double
    var inMeasure: String
    var ingredient: String
    var outMeasure: String
    var value: Double
    var date: Date
    
    init(id: UUID, inValue: Double, inMeasure: String, ingredient: String, outMeasure: String, value: Double, date: Date = Date()) {
        self.id = id
        self.inValue = inValue
        self.inMeasure = inMeasure
        self.ingredient = ingredient
        self.outMeasure = outMeasure
        self.value = value
        self.date = date
    }
}
