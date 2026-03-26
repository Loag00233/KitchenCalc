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
    var ingredients: [Ingredient] = []
    var selectedIngredient: Ingredient?
    var inValue: Double?
    var outValue: Double?
    var listOfMeasure: [Measure] = []
    var inMeasure: Measure = Measure(title: "Choose input measure", shortTitle: "", koefficient: 0, isWeight: false)
    var outMeasure: Measure = Measure(title: "Choose output measure", shortTitle: "", koefficient: 0, isWeight: false)
    var solveResults: [SolveResult] = []
    
    var showImperial: Bool = UserDefaults.standard.bool(forKey: "showImperial") {
        didSet {
            UserDefaults.standard.set(showImperial, forKey: "showImperial")
            updateMeasures()
        }
    }
    
    init() {
        getIngredients()
        updateMeasures()
    }
    
    func getIngredients() {
        self.ingredients = Ingredient.mockData
        if !self.ingredients.isEmpty {
            selectedIngredient = ingredients[0]
        }
    }
    
    func updateMeasures() {
        self.listOfMeasure = filteredMeasures()
        guard !listOfMeasure.isEmpty else { return }
        
        if showImperial == true { // если тогл в настройках вкл
            inMeasure = listOfMeasure.first { $0.isWeight && $0.isImperial } ?? listOfMeasure[0] // дефолтное входное знач = первое из списка имперских весов (oz)
            outMeasure = listOfMeasure.first { !$0.isWeight && $0.isImperial } ?? listOfMeasure[0] // дефолтное выходное знач = первое из списка имперских объемов (fl oz)
        } else {
            inMeasure = listOfMeasure.first { $0.isWeight } ?? listOfMeasure[0]
            outMeasure = listOfMeasure.first { !$0.isWeight } ?? listOfMeasure[0]
        }
    }
    
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
    
    func remember(context: ModelContext) {
        guard let inValue, let outValue, let selectedIngredient else {
            print("guard 1 failed — inValue: \(inValue), outValue: \(outValue), ingredient: \(selectedIngredient)")
            return }
        guard outMeasure.koefficient != 0 else {
            print("guard 2 failed — koefficient is 0")
            return }
        
        print("saving...")
        let solveResult = SolveResult(
            id: UUID().uuidString,
            inValue: inValue,
            inMeasure: inMeasure.shortTitle,
            ingredient: selectedIngredient.title,
            outMeasure: outMeasure.shortTitle,
            value: outValue)
        context.insert(solveResult)
    }
    
    func swapMeasures() {
        (inMeasure, outMeasure) = (outMeasure, inMeasure)
    }
    
    private func filteredMeasures() -> [Measure] {
        let measures = Measure.mockDataMeasure.filter { showImperial || !$0.isImperial }
        return measures
    }
    
}

