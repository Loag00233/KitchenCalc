//
//  ProductList.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 06.04.2026.
//

import SwiftUI

struct IngredientList: View {
    @Environment(IngredientsVM.self) private var ingredientsVM
    @State var ingredients: [Ingredient]
    var action: () -> ()
    
    var body: some View {
        
        List(ingredientsVM.ingredients) { ingredient in
            Button {
                ingredientsVM.selectedIngredient = ingredient
                action()
            } label: {
                HStack {
                    Text(ingredient.title)
                    ingredient.confidence.badge
                    Spacer()
                    Text("\(Double(ingredient.density).formatted(.number.precision(.fractionLength(0...2)) )) g/ml")
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .swipeActions {
                Button("Delete") {
                    ingredientsVM.deleteIngredient(ingredient)
                }
                .tint(.red)
            }
        }
    }
}
