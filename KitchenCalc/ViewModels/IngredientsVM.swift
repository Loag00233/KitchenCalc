//
//  IngredientsVM.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 09.04.2026.
//

import Foundation
import SwiftData

@Observable
class IngredientsVM {
    
    var selectedIngredient: Ingredient?
    var ingredients: [Ingredient] = []
    private var modelContext: ModelContext?
    
    private func fetchIngredients() {
        ingredients = (try? self.modelContext?.fetch(FetchDescriptor<Ingredient>(sortBy: [SortDescriptor(\.title)]))) ?? []
    }
    
    func setup(_ context: ModelContext) {
        self.modelContext = context
        fetchIngredients()
    }
    
    func save() {
        try? modelContext?.save()
    }
    
    func saveIngredient(title: String, density: Double) {
        guard !title.isEmpty else { return }
        guard density > 0 else { return }
        let ingredient = Ingredient(title: title, density: density)
        self.modelContext?.insert(ingredient)
        fetchIngredients()
        save()
    }
    
    func updateIngredient(title: String, density: Double?) {
        guard let selectedIngredient, let density else { return }
        selectedIngredient.title = title
        selectedIngredient.density = density
        save()
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        self.modelContext?.delete(ingredient)
        fetchIngredients()
        save()
    }
    
    func isIngredientDuplicate(title: String, excludingID: UUID? = nil) -> Bool {
        ingredients.contains {
            $0.id != excludingID && // exludes current edit Ingredient
            $0.title.lowercased() == title.lowercased() // compare to others
        }
    }
}
