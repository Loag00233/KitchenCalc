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
    var canSaveResult: Bool { inValue != nil && selectedIngredient != nil }
    
    func solve() {
        guard let inValue,
              let selectedIngredient,
              inMeasure.koefficient > 0,
              outMeasure.koefficient > 0
        else {
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
    
    func saveMeasure(title: String, shortTitle: String, koefficient: Double, isWeight: Bool, isImperial: Bool) {
        guard !title.isEmpty && !shortTitle.isEmpty else { return }
        guard koefficient > 0 else { return }
        let measure = Measure(title: title, shortTitle: shortTitle, koefficient: koefficient, isWeight: isWeight, isImperial: isImperial, isCustom: true)
        self.modelContext?.insert(measure)
        fetchMeasures()
        save()
    }
    
    func updateIngredient(title: String, density: Double?) {
        guard let selectedIngredient, let density else { return }
        selectedIngredient.title = title
        selectedIngredient.density = density
        try? self.modelContext?.save()
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        self.modelContext?.delete(ingredient)
        fetchIngredients()
        save()
    }
    
    func updateMeasure(_ measure: Measure, title: String, shortTitle: String, koefficient: Double, isImperial: Bool, isWeight: Bool) {
        measure.title = title
        measure.shortTitle = shortTitle
        measure.koefficient = koefficient
        measure.isWeight = isWeight
        measure.isImperial = isImperial
        try? self.modelContext?.save()
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
        if let defaultIn = filteredMeasures.first { inMeasure = defaultIn }
        if let defaultOut = filteredMeasures.last { outMeasure = defaultOut }
    }
    
    private func fetchIngredients() {
        ingredients = (try? self.modelContext?.fetch(FetchDescriptor<Ingredient>(sortBy: [SortDescriptor(\.title)]))) ?? []
    }
    
    private func fetchMeasures() {
        measures = (try? self.modelContext?.fetch(FetchDescriptor<Measure>(sortBy: [SortDescriptor(\.koefficient)] ))) ?? []
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
    
    func trimShortTitle(text: String) -> String {
        String(text.prefix(5))
    }
    
    func convertToKoefficient(input: Double, isWeight: Bool, isImperial: Bool) -> Double {
        if isWeight {
            return isImperial ? input * 28.3495 /* 1 ounce = 28.3495 g*/ : input /* thats gram*/
        } else {
            return isImperial ? input * 29.5735 /* 1 ml = 29.5735 fl oz */ : input  /*thats ml*/
        }
    }
    
}

