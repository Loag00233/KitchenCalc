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
        .navigationTitle("All products")
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
//    SettingsProductView()
//        .environment(CalcViewModel())
//}
