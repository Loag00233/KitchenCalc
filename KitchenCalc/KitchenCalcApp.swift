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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Ingredient.self, SolveResult.self, Measure.self]) { result in
            guard let container = try? result.get() else { return }
            let context = container.mainContext
            let existing = try? context.fetch(FetchDescriptor<Ingredient>())
            guard existing?.isEmpty == true else { return }  // уже засеяно — пропускаем
            Ingredient.mockData.forEach { context.insert($0) }
        }
    }
}
