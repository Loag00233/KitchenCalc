//
//  SettingsProductView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 06.04.2026.
//

import SwiftUI

struct SettingsProductView: View {
    @Environment(CalcViewModel.self) var viewModel
    @State private var showIngredientEditView = false
    
    var body: some View {
        ProductList(ingredients: viewModel.ingredients) {
            if viewModel.selectedIngredient != nil {
                showIngredientEditView = true
            }
        }
        .navigationTitle("Все продукты")
        .navigationDestination(isPresented: $showIngredientEditView) {
            AddIngredientView(isNew: false)
        }
    }
}

#Preview {
    SettingsProductView()
}
