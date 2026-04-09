//
//  ProductSheetView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 26.03.2026.
//

import SwiftUI
import SwiftData

struct IngredientSheetView: View {
    @State private var showAddIngredientSheet = false
    @Environment(IngredientsVM.self) private var ingredientsVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            IngredientList(ingredients: ingredientsVM.ingredients) {
                dismiss()
            }
            .navigationTitle("Select Ingredient")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink("Add") {
                        AddIngredientView(isNew: true)
                    }
                }
            }
            .sheet(isPresented: $showAddIngredientSheet) {
                AddIngredientView(isNew: true)
            }
        }
    }
}
