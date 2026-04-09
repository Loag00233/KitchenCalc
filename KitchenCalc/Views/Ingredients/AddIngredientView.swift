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
    @State private var showDuplicateError = false
    @Environment(IngredientsVM.self) private var ingredientsVM
    @Environment(\.dismiss) private var dismiss
    
    var confidenceBadge: Ingredient.DensityConfidence? {
        density.map { Ingredient.calcDensityBadge($0)
        }
    }
    
    var searchURL: URL {
        let query = "\(title.isEmpty ? "ingredient" : title) density g/mL"
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://www.google.com/search?q=\(encoded)")!
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: Spacing.extraLarge) {
                
                Text("Enter a name and density — the app will handle the rest")
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textSecondary)
                
                //MARK: Ingredient title
                VStack(alignment: .leading) {
                    Text("Name")
                    TextField("e.g. Almond flour", text: $title)
                        .modifier(TextFieldMod(isInvalid: showDuplicateError))
                }
                
                // MARK: Density
                VStack(alignment: .leading) {
                    Text("Density ") + Text("(g/mL)")
                        .font(.bodyRegular)
                        .foregroundStyle(Color.textSecondary)
                    
                    HStack{
                        //MARK: Ingredient Density
                        TextField("e.g. 0.45", value: $density, format: .number.grouping(.never))
                            .keyboardType(.decimalPad)
                        
                        //MARK: Ingredient Badge
                        if let confBadge = confidenceBadge {
                            confBadge.badge
                        }
                    }
                    .modifier(
                        TextFieldMod(isInvalid: false)
                    )
                    Text("Water = 1.0 · Milk ≈ 1.03 · Oil ≈ 0.92 · Flour ≈ 0.6")
                        .font(.bodyRegular)
                        .foregroundStyle(Color.textSecondary)
                }
                
                //MARK: Gray search card
                VStack(alignment: .leading, spacing: Spacing.small) {
                    
                    Text("Don't know the density?")
                        .font(.bodyRegular)
                        .foregroundStyle(Color.textSecondary)
                    
                    HStack {
                        Text("\(title.isEmpty ? "[ingredient name]" : title) density g/ml")
                            .font(.system(.caption, design: .monospaced))
                            .padding(Spacing.small)
                            .font(.viewTitle)
                        
                        Spacer()
                        
                        Link("Search", destination: searchURL)
                            .modifier(ButtonMod(color: .blue, verticalPadding: Spacing.small, isEnabled: true))
                            .frame(width: 80)
                    }
                }
                .padding(Spacing.large)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
                
                // MARK: Save Button
                VStack{
                    
                    if title.isEmpty || (density ?? 0) <= 0 {
                        Text("Fill in all fields to save")
                            .font(.bodyRegular)
                            .foregroundStyle(Color.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading) 
                    }
                    
                    Button("Save") {
                        showDuplicateError = false
                        
                        guard !ingredientsVM.isIngredientDuplicate(title: title, excludingID: isNew ? nil : ingredientsVM.selectedIngredient?.id ) else {
                            showDuplicateError = true
                            return }
                        
                        isNew ? ingredientsVM.saveIngredient(title: title, density: density ?? 0) : ingredientsVM.updateIngredient(title: title, density: density)
                        dismiss()
                    }
                    .modifier(ButtonMod(color: .blue,
                                        isEnabled: !title.isEmpty && (density ?? 0) > 0))
                }
                
                if showDuplicateError {
                    Text("This Ingredient already exists")
                        .foregroundStyle(.red)
                }
                
            }
            .navigationTitle(isNew ? "New Ingredient" : "Edit Ingredient")
            .padding(.horizontal, Spacing.medium)
            .modifier(KeyboardOk())
            .hideKeyboardOnTap()
            .onAppear{
                if !isNew {
                    if let ingredient = ingredientsVM.selectedIngredient {
                        self.title = ingredient.title
                        self.density = ingredient.density
                    }
                }
            }
        }
    }
    
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Measure.self, Ingredient.self, configurations: config)
//    let vm = CalcResultVM()
//    NavigationStack {
//        AddIngredientView(isNew: true)
//    }
//    .environment(vm)
//    .modelContainer(container)
//}
