//
//  CustomMeasuresView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 30.03.2026.
//

import SwiftUI
import SwiftData

struct CustomMeasuresView: View {
    
    @State private var showAddSheet = false
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Measure> {$0.isCustom} ) var customMeasures: [Measure]
    
    var body: some View {
        
        Group {
            if customMeasures.isEmpty {
                ContentUnavailableView {
                    Label("No custom measures", systemImage: "ruler")
                } description: {
                    Text("You haven't added any measures yet.")
                } actions: {
                    Button("Add New Measure") {
                        showAddSheet = true
                    }
                }
            } else {
                List(customMeasures) { measure in
                    HStack{
                        Text(measure.displayTitle)
                        Text("(\(measure.displayShortTitle))")
                        Spacer()
                        Text(measure.isWeight ? "Weight" : "Volume" )
                    }
                }
                .toolbar{
                    Button("Add") {showAddSheet = true }
                }
            }
        }
        .navigationTitle("List of your measures")
        .sheet(isPresented: $showAddSheet) {
            AddMeasureView()
        }
        
    }
}

#Preview {
    CustomMeasuresView()
}

