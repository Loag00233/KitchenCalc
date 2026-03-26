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
    var inMeasure: String
    var ingredient: String
    var outMeasure: String
    var value: Double
    
    init(id: String, inValue: Double, inMeasure: String, ingredient: String, outMeasure: String, value: Double) {
        self.id = id
        self.inValue = inValue
        self.inMeasure = inMeasure
        self.ingredient = ingredient
        self.outMeasure = outMeasure
        self.value = value
    }
}
