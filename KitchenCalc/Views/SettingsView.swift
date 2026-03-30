//
//  SettingsView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 25.03.2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("showImperial") private var showImperial = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Imperial units", isOn: $showImperial)
                } footer: {
                    Text("Show ounces, pounds, fluid ounces, and pints in the unit picker.")
                }
                
                Button ("Custom units") {
                    
                }
                
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
