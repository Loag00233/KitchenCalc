//
//  ProductList.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 06.04.2026.
//

import SwiftUI

struct ProductList: View {
    @Environment(CalcViewModel.self) private var viewModel
    @State var ingredients: [Ingredient]
    var action: () -> ()
    
    var body: some View {
        List(viewModel.ingredients) { ingredient in
            Button {
                viewModel.selectedIngredient = ingredient
                action()
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
                .tint(.red)
            }
        }
    }
}
