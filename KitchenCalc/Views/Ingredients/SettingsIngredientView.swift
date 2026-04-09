//
//  SettingsProductView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 06.04.2026.
//

import SwiftUI

struct SettingsIngredientView: View {
    @Environment(IngredientsVM.self) var ingredientsVM
    @State private var showIngredientEditView = false
    
    var body: some View {
        IngredientList(ingredients: ingredientsVM.ingredients) {
            if ingredientsVM.selectedIngredient != nil {
                showIngredientEditView = true
            }
        }
        .navigationTitle("All Ingredients")
        .navigationDestination(isPresented: $showIngredientEditView) {
            AddIngredientView(isNew: false)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink("Add") {
                    AddIngredientView(isNew: true)
                }
            }
        }
    }
}

//#Preview {
//    SettingsIngredientView()
//        .environment(CalcResultVM())
//}
