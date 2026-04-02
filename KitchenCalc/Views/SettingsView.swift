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
                    Text("Show ounces, pounds, fluid ounces, and pints in the unit picker.")
                }
                
//                NavigationLink ("List of your products") {
//                    ProductSheetView()
//                }
                
                NavigationLink("List of your measures") {
                    CustomMeasuresView()
                }
                
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
