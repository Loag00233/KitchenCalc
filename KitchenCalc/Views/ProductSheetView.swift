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
    
    var body: some View {
        NavigationStack {
            List(ingredients) { ingredient in
                Button(ingredient.title) {
                    selectedIngredient = ingredient
                    dismiss()
                }
            }
            .navigationTitle("Select product")
        }
    }
}
