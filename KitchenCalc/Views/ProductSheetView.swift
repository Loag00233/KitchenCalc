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
    @Environment(\.dismiss) private var dismiss
    @Query var ingredients: [Ingredient]
    @State private var showAddIngredientSheet = false
    
    var body: some View {
        NavigationStack {
            List(ingredients) { ingredient in
                Button {
                    selectedIngredient = ingredient
                    dismiss()
                } label: {
                    HStack {
                        Text(ingredient.title)
                        Spacer()
                        Text("\(Int(ingredient.density)) kg/m³")
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
            .navigationTitle("Select product")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("", systemImage: "plus") {
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
