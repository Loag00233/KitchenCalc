//
//  ContentView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 24.03.2026.
//

import SwiftUI

struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
}
