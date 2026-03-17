//
//  ViewModel.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 15.02.2026.
//

import Foundation

@Observable
class CalcViewModel {
    var ingredients: [Ingredient] = []
    var selectedIngredient: Ingredient?
    var inValue: Double?
    var outValue: Double?
    var listOfMeasure: [Measure] = []
    var inMeasure: Measure = Measure(title: "Choose input measure", koefficient: 0, isWeight: false)
    var outMeasure: Measure = Measure(title: "Choose output measure", koefficient: 0, isWeight: false)
    var showError: Bool = false
    var solveResults: [SolveResult] = []
    
    init() {
        getIngredients()
        getMeasures()
    }
    
    func getIngredients() {
        self.ingredients = Ingredient.mockData
        if !self.ingredients.isEmpty {
            selectedIngredient = ingredients[0]
        }
    }
    
    func getMeasures() {
        self.listOfMeasure = Measure.mockData
        if !self.listOfMeasure.isEmpty {
            inMeasure = listOfMeasure[0]
            outMeasure = listOfMeasure[0]
        }
    }
    
    func solve() {
        guard let inValue,
              let selectedIngredient else {
            self.showError = true
            return
        }
        
        // добавить guard inMeasure.koeff / ouMeasure.koef не равен 0
        
        /// Варианты решения
        ///
        /// 1) если одинаковые величины одного типа (масса-масса, объем - объем)
        /// outValue = inValue * inKoef / outKoef
        ///
        /// 2) масса - объем
        /// перевести 2кг муки в литры
        /// 2кг / плотность муки
        ///
        /// 3) объем - масса
        
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
    
    func remember() {
        guard let inValue, let outValue, let selectedIngredient else { return }
        guard outMeasure.koefficient != 0 else { return }
        
        let solveResult = SolveResult(
            id: UUID().uuidString,
            inValue: inValue,
            inMeasureTitle: inMeasure.title,
            ingredientTitle: selectedIngredient.title,
            outMeasureTitle: outMeasure.title,
            value: outValue)
        self.solveResults.append(solveResult)
    }
}

