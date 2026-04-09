//
//  ViewModel.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 15.02.2026.
//

import Foundation
import SwiftData

@Observable
class CalcResultVM {
    
    private var modelContext: ModelContext?
    
    var inValue: Double?
    var outValue: Double?
    var solveResults: [SolveResult] = []
    
    func setup(_ context: ModelContext) {
         self.modelContext = context
         fetchSolveResults()
     }

    func solve(inValue: Double?, inMeasure: Measure, outMeasure: Measure, ingredient: Ingredient?) {
        guard let inValue,
              let ingredient,
              inMeasure.koefficient > 0,
              outMeasure.koefficient > 0
        else {
            self.outValue = nil
            return }
        
        let types = (inMeasure.isWeight, outMeasure.isWeight)
        var result: Double = 0
        
        switch types {
            // величины одного типа
        case (true, true), (false, false):
            result = inValue * inMeasure.koefficient / outMeasure.koefficient
            // величины масса -> объем
        case (true, false):
            result = inValue * inMeasure.koefficient / ingredient.density / outMeasure.koefficient
            // величины объем -> масса
        case (false, true):
            result = inValue * inMeasure.koefficient * ingredient.density / outMeasure.koefficient
        }
        self.outValue = result
    }
    
    private func save() {
        try? modelContext?.save()
    }
    
    func canSaveResult(ingredient: Ingredient?) -> Bool {
        inValue != nil && ingredient != nil
    }
    
    func saveSolveResult(inValue: Double?, inMeasure: Measure, outMeasure: Measure, ingredient: Ingredient?) {
        guard let inValue, let outValue, let ingredient else { return }
        guard inValue > 0, outValue > 0 else { return }
        
        let solveResult = SolveResult(
            id: UUID(),
            inValue: inValue,
            inMeasure: inMeasure.displayShortTitle,
            ingredient: ingredient.title,
            outMeasure: outMeasure.displayShortTitle,
            value: outValue)
        self.modelContext?.insert(solveResult)
        fetchSolveResults()
        save()
    }
    
    func deleteSolveResult(_ solveResult: SolveResult) {
        self.modelContext?.delete(solveResult)
        fetchSolveResults()
        save()
    }
    
    private func fetchSolveResults() {
        solveResults = (try? self.modelContext?.fetch(FetchDescriptor<SolveResult>(sortBy: [SortDescriptor(\.date, order: .reverse )] ))) ?? []
    }
    
    
}

