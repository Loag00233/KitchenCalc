//
//  ProductSheetView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 26.03.2026.
//

import SwiftUI
import SwiftData

struct ProductSheetView: View {
    @State private var showAddIngredientSheet = false
    @Environment(CalcViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ProductList(ingredients: viewModel.ingredients) {
                dismiss()
            }
            .navigationTitle("Select product")
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
