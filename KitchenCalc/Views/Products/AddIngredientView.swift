//
//  AddIngredientView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 27.03.2026.
//

import SwiftUI

struct AddIngredientView: View {
    let isNew: Bool
    @State private var title: String = ""
    @State private var density: Double?
    @State private var showValidation = false
    @Environment(CalcViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            
            VStack(alignment: .leading, spacing: Spacing.large) {
                TextField("Ingredient title", text: $title)
                    .modifier(TextFieldMod(isInvalid: showValidation && title.isEmpty))
                
                TextField("Ingredient's density", value: $density, format: .number)
                    .keyboardType(.decimalPad)
                    .modifier(
                        TextFieldMod(isInvalid: densityValidation())
                    )
                
                Button("Save") {
                    guard viewModel.checkNewIngredientIsValid(title: title, density: density ?? 0 ) else {
                        showValidation = true
                        return
                    }
                    isNew ? viewModel.saveIngredient(title: title, density: density ?? 0) : viewModel.updateIngredient(title: title, density: density)
                    dismiss()
                }
                .modifier(ButtonMod(color: .blue))
                
                if showValidation {
                    Text("Please fill in all fields")
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle(isNew ? "New Ingredient" : "Edit Ingredient")
            .padding(.horizontal, Spacing.medium)
            .modifier(KeyboardOk())
            .hideKeyboardOnTap()
            .onAppear{
                if !isNew {
                    if let ingredient = viewModel.selectedIngredient {
                        self.title = ingredient.title
                        self.density = ingredient.density
                    }
                }
            }
    }
    
    func densityValidation() -> Bool {
        return showValidation && (density ?? 0) <= 0
    }
    
}
