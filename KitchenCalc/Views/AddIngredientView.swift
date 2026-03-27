//
//  AddIngredientView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 27.03.2026.
//

import SwiftUI
import SwiftData

struct AddIngredientView: View {
    @State private var title: String = ""
    @State private var density: Double?
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            Text("New Ingredient")
                .font(Font.productTitle)
            TextField("Ingredient title", text: $title)
                .modifier(KeyboardOk())
                .modifier(TextFieldMod())
            TextField("Ingredient's density", value: $density, format: .number)
                .keyboardType(.decimalPad)
                .modifier(TextFieldMod())
            Button{
                saveIngredient()
                dismiss()
            } label: {
                Text("Save")
                    .modifier(ButtonMod(color: .accent))
            }
        }
        .padding(.horizontal, Spacing.medium)
        .hideKeyboardOnTap()
        
    }
    
    private func saveIngredient() {
        guard let density, density > 0 else {return}
        guard !title.isEmpty else {return}
        let ingredient = Ingredient(title: title, density: density)
        modelContext.insert(ingredient)
        try? modelContext.save()
    }
}

#Preview {
    AddIngredientView()
}
