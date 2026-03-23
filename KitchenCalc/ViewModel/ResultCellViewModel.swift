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
    
    var inMeasureTitle: String {
        guard let measure = Measure.searchByID(result.inMeasureID) else {
            return "NotFound"
        }
        return measure.shortTitle
    }
    
    var outMeasureTitle: String {
        guard let measure = Measure.searchByID(result.outMeasureID) else
        {
            return "Not Found"
        }
        return measure.shortTitle
    }
    
    init(result: SolveResult) {
        self.result = result
    }
        
    func getIngerdient() {
        
    }
     
}
