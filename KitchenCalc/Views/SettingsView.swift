//
//  SettingsView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 25.03.2026.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(CalcViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            Form {
                
                Section {
                    Toggle("Imperial units", isOn: $viewModel.showImperial)
                } footer: {
                    Text("Show ounces, pounds, fluid ounces, and pints in the unit picker")
                }
                
                Section {
                    NavigationLink("List of your ingredients") {
                        SettingsProductView()
                    }
                } footer: {
                    Text("Customize your Ingredient list. Add / Edit / Delete ingredients with density values")
                }
                
                Section {
                    NavigationLink("List of your measures") {
                        CustomMeasureListView()
                    }
                } footer: {
                    Text("Customize your list of Measures. Add / Edit / Delete units of measurement to convert ingredients them accurately")
                }
            }
            .navigationTitle("Settings")
        }
    }
    
}

//#Preview {
//    SettingsView()
//}
