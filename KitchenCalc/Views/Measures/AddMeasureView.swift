//
//  AddMeasureView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 31.03.2026.
//

import SwiftUI

struct AddMeasureView: View {
    
    let isNew: Bool
    let measure: Measure?
    @State private var title: String = ""
    @State private var shortTitle: String = ""
    @State private var koefficient: Double?
    @State private var isWeight: Bool = true
    @State private var showValidation = false
    @Environment(CalcViewModel.self) private var viewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
//        NavigationStack {
            
            VStack {
                TextField("Title", text: $title)
                    .modifier(TextFieldMod(isInvalid: showValidation && title.isEmpty))
                
                TextField("ShortTitle", text: $shortTitle)
                    .modifier(TextFieldMod(isInvalid: showValidation && shortTitle.isEmpty))
                
                TextField("Koefficient", value: $koefficient, format: .number)
                    .modifier(
                        TextFieldMod(isInvalid: measureValidation())
                    )
                    .keyboardType(.decimalPad)
                
                Picker("Type", selection: $isWeight) {
                    Text("Weight").tag(true)
                    Text("Volume").tag(false)
                }
                .pickerStyle(.segmented)
                
                Button("Save") {
                    guard viewModel.checkNewMeasureIsValid(title: title, shortTitle: shortTitle, koefficient: koefficient ?? 0) else {
                        showValidation = true
                        return
                    }
                    isNew ?
                    viewModel.saveMeasure(title: title, shortTitle: shortTitle, koefficient: koefficient ?? 0, isWeight: isWeight) :
                    viewModel.updateMeasure(measure!, title: title, shortTitle: shortTitle, koefficient: koefficient ?? 0, isWeight: isWeight)
                    dismiss()
                }
                .modifier(ButtonMod(color: .blue))
                if showValidation {
                    Text("Please fill in all fields")
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle(isNew ? "New Measure" : "Edit Measure")
            .padding(.horizontal, Spacing.medium)
            .modifier(KeyboardOk())
            .hideKeyboardOnTap()
            .onAppear{
                if !isNew {
                    title = measure?.title ?? ""
                    shortTitle = measure?.shortTitle ?? ""
                    koefficient = measure?.koefficient
                    isWeight = measure?.isWeight ?? true
                    }
                }
//        }
    }
    
    func measureValidation() -> Bool {
        return showValidation && (koefficient ?? 0) <= 0
    }
}
