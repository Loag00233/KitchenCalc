//
//  CustomMeasuresView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 30.03.2026.
//

import SwiftUI
import SwiftData

struct MeasureListView: View {
    
    
    @Environment(MeasuresVM.self) private var measuresVM
    
    var body: some View {
        
        List {
            
            Section("Custom") {
                if measuresVM.customMeasures.isEmpty {
                    Text("No custom measures yet")
                        .foregroundStyle(Color.textSecondary)
                } else {
                    ForEach(measuresVM.customMeasures) {
                        measure in
                        NavigationLink{
                            AddMeasureView(isNew: false, measure: measure)
                        } label: {
                            HStack{
                                Text(measure.displayTitle)
                                Text("(\(measure.displayShortTitle))")
                                Spacer()
                                Text(measure.isWeight ? "Weight" : "Volume" )
                            }
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                measuresVM.deleteMeasure(measure)
                            }
                        }
                    }
                }
            }
            
            Section("Default") {
                ForEach(measuresVM.measures.filter { !$0.isCustom }) { measure in
                    HStack{
                        Text(measure.displayTitle)
                        Text("(\(measure.displayShortTitle))")
                        Spacer()
                        Text(measure.isWeight ? "Weight" : "Volume" )
                    }
                }
            }
        }
        .navigationTitle("All Measures")
        .toolbar {
            NavigationLink{
                AddMeasureView(isNew: true, measure: nil)
            }label: {
                Text("Add")
            }
        }
}
}
