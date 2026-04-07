//
//  CustomMeasuresView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 30.03.2026.
//

import SwiftUI
import SwiftData

struct CustomMeasureListView: View {
    
    @State private var showAddSheet = false
    @Environment(CalcViewModel.self) private var viewModel
    
    var body: some View {
        
        Group {
            if viewModel.customMeasures.isEmpty {
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
                List(viewModel.customMeasures) { measure in
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
            AddMeasureView(isNew: true, measure: nil)
        }
        
    }
}

#Preview {
    CustomMeasureListView()
}

