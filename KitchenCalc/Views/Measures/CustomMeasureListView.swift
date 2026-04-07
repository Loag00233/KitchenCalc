//
//  CustomMeasuresView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 30.03.2026.
//

import SwiftUI
import SwiftData

struct CustomMeasureListView: View {
    
    //@State private var showAddSheet = false
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
                        NavigationLink(AddMeasureView(isNew: true, measure: nil))
                    }
                }
            } else {
                List(viewModel.customMeasures) { measure in
                    NavigationLink(value: measure){
                        HStack{
                            Text(measure.displayTitle)
                            Text("(\(measure.displayShortTitle))")
                            Spacer()
                            Text(measure.isWeight ? "Weight" : "Volume" )
                        }
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            viewModel.deleteMeasure(measure)
                        }
                    }
                    .toolbar{
                        NavigationLink{
                            AddMeasureView(isNew: true, measure: nil)
                        }label: {
                            Text("Add")
                        }
                        
                        
                    }
                    .navigationDestination(for: Measure.self) { measure in
                        AddMeasureView(isNew: false, measure: measure)
                    }
                    .navigationTitle("List of your measures")
                }
            }
        }
    }
}
