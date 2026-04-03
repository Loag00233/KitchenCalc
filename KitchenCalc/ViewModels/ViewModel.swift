//
//  ViewModel.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 15.02.2026.
//

import Foundation
import SwiftData

@Observable
class CalcViewModel {
    
    private var modelContext: ModelContext?
    
    var selectedIngredient: Ingredient?
    var inValue: Double?
    var outValue: Double?
    var inMeasure: Measure = Measure(title: "Choose input measure", shortTitle: "", koefficient: 0, isWeight: false)
    var outMeasure: Measure = Measure(title: "Choose output measure", shortTitle: "", koefficient: 0, isWeight: false)
    var ingredients: [Ingredient] = []
    var measures: [Measure] = []
    var solveResults: [SolveResult] = []
    var showImperial: Bool = UserDefaults.standard.bool(forKey: "showImperial") {
        didSet {UserDefaults.standard.set(showImperial, forKey: "showImperial")}
    }
    var filteredMeasures: [Measure] {showImperial ? self.measures : measures.filter { !$0.isImperial }}
    var customMeasures: [Measure] { measures.filter{$0.isCustom} }
    
    
    func solve() {
        guard let inValue,
              let selectedIngredient else {
            self.outValue = nil
            return
        }
        
        let types = (inMeasure.isWeight, outMeasure.isWeight)
        var result: Double = 0
        
        switch types {
            // величины одного типа
        case (true, true), (false, false):
            result = inValue * inMeasure.koefficient / outMeasure.koefficient
            // величины масса -> объем
        case (true, false):
            result = inValue * inMeasure.koefficient / selectedIngredient.density / outMeasure.koefficient
            // величины объем -> масса
        case (false, true):
            result = inValue * inMeasure.koefficient * selectedIngredient.density / outMeasure.koefficient
        }
        self.outValue = result
    }
    
    private func save() {
        try? modelContext?.save()
    }
    
    func saveSolveResult() {
        guard let inValue, let outValue, let selectedIngredient else { return }
        guard inValue > 0, outValue > 0 else { return }
        
        let solveResult = SolveResult(
            id: UUID(),
            inValue: inValue,
            inMeasure: inMeasure.displayShortTitle,
            ingredient: selectedIngredient.title,
            outMeasure: outMeasure.displayShortTitle,
            value: outValue)
        self.modelContext?.insert(solveResult)
        fetchSolveResults()
        save()
    }
    
    func saveIngredient(title: String, density: Double) {
        guard !title.isEmpty else { return }
        guard density > 0 else { return }
        let ingredient = Ingredient(title: title, density: density)
        self.modelContext?.insert(ingredient)
        fetchIngredients()
        save()
    }
    
    func saveMeasure(title: String, shortTitle: String, koefficient: Double, isWeight: Bool) {
        guard !title.isEmpty && !shortTitle.isEmpty else { return }
        guard koefficient > 0 else { return }
        let measure = Measure(title: title, shortTitle: shortTitle, koefficient: koefficient, isWeight: isWeight, isCustom: true)
        self.modelContext?.insert(measure)
        fetchMeasures()
        save()
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        self.modelContext?.delete(ingredient)
        fetchIngredients()
        save()
    }
    
    func deleteMeasure(_ measure: Measure) {
        self.modelContext?.delete(measure)
        fetchMeasures()
        save()
    }
    
    func deleteSolveResult(_ solveResult: SolveResult) {
        self.modelContext?.delete(solveResult)
        fetchSolveResults()
        save()
    }
    
    func swapMeasures() {
        (inMeasure, outMeasure) = (outMeasure, inMeasure)
    }
    
    func setup(_ context: ModelContext) {
        self.modelContext = context
        fetchAll()
    }
    
    private func fetchIngredients() {
        ingredients = (try? self.modelContext?.fetch(FetchDescriptor<Ingredient>())) ?? []
    }
    
    private func fetchMeasures() {
        measures = (try? self.modelContext?.fetch(FetchDescriptor<Measure>())) ?? []
    }
    
    private func fetchSolveResults() {
        solveResults = (try? self.modelContext?.fetch(FetchDescriptor<SolveResult>(sortBy: [SortDescriptor(\.date, order: .reverse )] ))) ?? []
    }
    
    private func fetchAll() {
        fetchIngredients()
        fetchMeasures()
        fetchSolveResults()
    }
    
    func checkNewMeasureIsValid(title: String, shortTitle: String, koefficient: Double) -> Bool {
        !title.isEmpty && !shortTitle.isEmpty && koefficient > 0
    }
    
    func checkNewIngredientIsValid(title: String, density: Double) -> Bool {
        !title.isEmpty && density > 0
    }
    
}

