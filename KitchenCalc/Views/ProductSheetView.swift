//
//  ProductSheetView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 26.03.2026.
//

import SwiftUI
import SwiftData

struct ProductSheetView: View {
    @Binding var selectedIngredient: Ingredient?
    @State private var showAddIngredientSheet = false
    @Environment(CalcViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(viewModel.ingredients) { ingredient in
                Button {
                    selectedIngredient = ingredient
                    dismiss()
                } label: {
                    HStack {
                        Text(ingredient.title)
                        ingredient.badge
                        Spacer()
                        Text("\(Int(ingredient.density)) kg/m³")
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                .swipeActions {
                    Button("Delete") {
                        viewModel.deleteIngredient(ingredient)
                    }
                }
            }
            .navigationTitle("Select product")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        showAddIngredientSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $showAddIngredientSheet) {
                AddIngredientView()
            }
        }
    }
}
