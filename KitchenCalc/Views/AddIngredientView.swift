//
//  AddIngredientView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 27.03.2026.
//

import SwiftUI

struct AddIngredientView: View {
    @State private var title: String = ""
    @State private var density: Double = 0
    @State private var showValidation = false
    @Environment(CalcViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading, spacing: Spacing.large) {
                TextField("Ingredient title", text: $title)
                    .modifier(KeyboardOk())
                    .modifier(TextFieldMod(isInvalid: showValidation && title.isEmpty))
                
                TextField("Ingredient's density", value: $density, format: .number)
                    .keyboardType(.decimalPad)
                    .modifier(TextFieldMod(isInvalid: showValidation && density <= 0))
                
                Button("Save") {
                    guard viewModel.checkNewIngredientIsValid(title: title, density: density) else {
                        showValidation = true
                        return
                    }
                    viewModel.saveIngredient(title: title, density: density)
                    dismiss()
                }
                .modifier(ButtonMod(color: .blue))
                
                if showValidation {
                    Text("Please fill in all fields")
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("New Ingredient")
            .padding(.horizontal, Spacing.medium)
            .hideKeyboardOnTap()
        }
    }
}
