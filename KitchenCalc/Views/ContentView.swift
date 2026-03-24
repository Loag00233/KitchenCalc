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
            ConverterView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Converter")
                }

            Text("Settings")
                .tabItem {
                    Image(systemName: "person.badge.plus")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
}
