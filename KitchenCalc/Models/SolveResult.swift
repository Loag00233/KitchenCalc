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
    var id: String
    var inValue: Double
    @Relationship( deleteRule: .noAction) var inMeasure: Measure
    var inMeasureID: String
    var ingredientTitleID: String
    var outMeasureID: String
    var value: Double
    
    init(id: String, inValue: Double, inMeasure: Measure, inMeasureID: String, ingredientTitleID: String, outMeasureID: String, value: Double) {
        self.id = id
        self.inValue = inValue
        self.inMeasure = inMeasure
        self.inMeasureID = inMeasureID
        self.ingredientTitleID = ingredientTitleID
        self.outMeasureID = outMeasureID
        self.value = value
    }
}
