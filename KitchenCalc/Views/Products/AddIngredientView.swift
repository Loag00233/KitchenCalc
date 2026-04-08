//
//  AddIngredientView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 27.03.2026.
//

import SwiftUI
import SwiftData

struct AddIngredientView: View {
    let isNew: Bool
    @State private var title: String = ""
    @State private var density: Double?
    @State private var showValidation = false
    @Environment(CalcViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: Spacing.extraLarge) {
                
                Text("Create a custom unit of measurement. It will appear in the converter's unit list.")
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textSecondary)
                
                VStack(alignment: .leading) {
                    Text("Name")
                    TextField("e.g. Almond flour", text: $title)
                        .modifier(TextFieldMod(isInvalid: showValidation && title.isEmpty))
                }
                
                VStack(alignment: .leading) {
                    Text("Density ") + Text("(g/mL)").foregroundStyle(Color.textSecondary)
                    TextField("e.g. 0.45", value: $density, format: .number.grouping(.never))
                        .keyboardType(.decimalPad)
                        .modifier(
                            TextFieldMod(isInvalid: densityValidation())
                        )
                }
                
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
    }
    
    func densityValidation() -> Bool {
        return showValidation && (density ?? 0) <= 0
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Measure.self, Ingredient.self, configurations: config)
    let vm = CalcViewModel()
    NavigationStack {
        AddIngredientView(isNew: true)
    }
    .environment(vm)
    .modelContainer(container)
}
