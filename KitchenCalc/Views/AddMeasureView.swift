//
//  AddMeasureView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 31.03.2026.
//

import SwiftUI
import SwiftData

struct AddMeasureView: View {
    
    @State private var title: String = "title"
    @State private var shortTitle: String = "shrt"
    @State private var koefficient: Double = 0
    @State private var isWeight: Bool = true
    @State private var isCustom: Bool = true
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        TextField("Title", text: $title)
        TextField("ShortTitle", text: $shortTitle)
        TextField("Koefficient", value: $koefficient, format: .number)
            .keyboardType(.decimalPad)
        Picker("Type", selection: $isWeight) {
              Text("Weight").tag(true)
              Text("Volume").tag(false)
          }
          .pickerStyle(.segmented)
        Button("Save") {
            saveMeasure()
            dismiss()
        }
    }
    
    private func saveMeasure() {
        guard !title.isEmpty, !shortTitle.isEmpty, !koefficient.isNaN else { return }
        let newMeasure = Measure(title: title, shortTitle: shortTitle, koefficient: koefficient, isWeight: isWeight, isCustom: true)
        modelContext.insert(newMeasure)
        try? modelContext.save()
    }
}

#Preview {
    AddMeasureView()
}
