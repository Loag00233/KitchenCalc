//
//  SettingsView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 25.03.2026.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(MeasuresVM.self) private var measuresVM
    
    var body: some View {
        @Bindable var measuresVM = measuresVM
        NavigationStack {
            Form {
                
                Section {
                    NavigationLink("List of your ingredients") {
                        SettingsIngredientView()
                    }
                } footer: {
                    Text("Customize your Ingredient list. Add / Edit / Delete ingredients with density values")
                }
                
                Section {
                    NavigationLink("List of your measures") {
                        MeasureListView()
                    }
                } footer: {
                    Text("Customize your list of Measures. Add / Edit / Delete units of measurement to convert ingredients accurately")
                }
                
                Section {
                    Toggle("Imperial units", isOn: $measuresVM.showImperial)
                } footer: {
                    Text("Show ounces, pounds, fluid ounces, and pints in the unit picker")
                }
            }
            .navigationTitle("Settings")
        }
    }
    
}

//#Preview {
//    SettingsView()
//}
