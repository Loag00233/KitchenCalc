//
//  Result.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 19.02.2026.
//

import Foundation

struct SolveResult: Identifiable {
    let id: String
    let inValue: Double
    let inMeasureTitle: String
    let ingredientTitle: String
    let outMeasureTitle: String
    let value: Double
}
