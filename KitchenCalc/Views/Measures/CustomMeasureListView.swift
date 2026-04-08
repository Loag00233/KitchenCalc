//
//  CustomMeasuresView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 30.03.2026.
//

import SwiftUI
import SwiftData

struct CustomMeasureListView: View {
    
    
    @Environment(CalcViewModel.self) private var viewModel
    
    var body: some View {
        Group {
            if viewModel.customMeasures.isEmpty {
                ContentUnavailableView {
                    Label("No custom measures", systemImage: "ruler")
                } description: {
                    Text("You haven't added any measures yet.")
                } actions: {
                    NavigationLink("Add New Measure") { AddMeasureView(isNew: true, measure: nil) }
                }
            } else {
                List(viewModel.customMeasures) { measure in
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
                            viewModel.deleteMeasure(measure)
                        }
                    }
                }
                .toolbar {
                    NavigationLink{
                        AddMeasureView(isNew: true, measure: nil)
                    }label: {
                        Text("Add")
                    }
                }
                .navigationTitle("List of your measures")
            }
        }
    }
}
