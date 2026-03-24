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
    let inMeasureID: String
    let ingredientTitleID: String
    let outMeasureID: String
    let value: Double
}
