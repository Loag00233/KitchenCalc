//
//  KitchenCalcApp.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 14.02.2026.
//

import SwiftUI
import SwiftData

@main
struct KitchenCalcApp: App {
    
    @State private var calcResultVM = CalcResultVM()
    @State private var ingredientsVM = IngredientsVM()
    @State private var measuresVM = MeasuresVM()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(calcResultVM)
                .environment(ingredientsVM)
                .environment(measuresVM)
        }
        .modelContainer(for: [Ingredient.self, SolveResult.self, Measure.self]) { result in
            guard let container = try? result.get() else { return }
            let context = container.mainContext
            guard let existingIngridients = try? context.fetch(FetchDescriptor<Ingredient>()),
                existingIngridients.isEmpty else { return }
            Ingredient.mockData.forEach { context.insert($0) }
            guard let existingMeasures = try? context.fetch(FetchDescriptor<Measure>()),
                existingMeasures.isEmpty else { return }
            Measure.mockDataMeasure.forEach { context.insert($0) }
        }
    }
}
