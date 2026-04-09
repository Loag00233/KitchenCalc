//
//  ContentView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 24.03.2026.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(CalcResultVM.self) private var calcResultVM
    @Environment(IngredientsVM.self) private var ingredientsVM
    @Environment(MeasuresVM.self) private var measuresVM
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            CalcView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Converter")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .onAppear {
            calcResultVM.setup(modelContext)
            ingredientsVM.setup(modelContext)
            measuresVM.setup(modelContext)
        }
    }
}

#Preview {
    ContentView()
}
