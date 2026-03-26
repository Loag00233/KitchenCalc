//
//  ResultCellViewModel.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 23.03.2026.
//

import Foundation

@Observable
class ResultCellViewModel {
    var result: SolveResult
    var inMeasureTitle: String { result.inMeasure }
    var outMeasureTitle: String { result.outMeasure }
    var ingredientTitle: String { result.ingredient }
    
    init(result: SolveResult) {
        self.result = result
    }
}
