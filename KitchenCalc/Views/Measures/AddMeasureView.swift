//
//  AddMeasureView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 31.03.2026.
//
import SwiftData
import SwiftUI

struct AddMeasureView: View {
    
    let isNew: Bool
    let measure: Measure?
    @State private var title: String = ""
    @State private var shortTitle: String = ""
    @State private var inputKoefficient: Double?
    @State private var isWeight: Bool = true
    @State private var showDuplicateError = false
    @State private var isImperial: Bool = false
    
    @Environment(CalcViewModel.self) private var viewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: Spacing.extraLarge) {
                Text("Create a custom unit of measurement. It will appear in the converter's unit list. \ne.g. My mug holds 350ml — add it once, use it forever")
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textSecondary)
                
                //MARK: Title
                VStack(alignment: .leading) {
                    Text("Name")
                    TextField("e.g. Cup 200 ml", text: $title)
                        .modifier(TextFieldMod(isInvalid: showDuplicateError))
                }
                
                //MARK: Short title
                VStack(alignment: .leading) {
                    Text("Abbreviation ") + Text("(5 chars max)").foregroundStyle(Color.textSecondary)
                    TextField("cup", text: $shortTitle)
                        .onChange(of: shortTitle) {
                            shortTitle = viewModel.trimShortTitle(text: shortTitle)
                        }
                        .modifier(TextFieldMod(isInvalid: showDuplicateError))
                    Text("Shown in the unit picker")
                        .font(.caption)
                        .foregroundStyle(Color.textTertiary)
                }
                
                //MARK: Weight or Volume
                Picker("Type", selection: $isWeight) {
                    Text("Weight").tag(true)
                    Text("Volume").tag(false)
                }
                .pickerStyle(.segmented)
                
                //MARK: Koefficient. How much g / fl in Weight OR ml / fl oz in Volume
                VStack(alignment: .leading) {
                    Text("How many g or ml is one \(title.isEmpty ? "unit" : title ) ?")
                    HStack {
                        TextField("e.g. 200", value: $inputKoefficient, format: .number.grouping(.never))
                            .keyboardType(.decimalPad)
                        
                        Picker("", selection: $isImperial) {
                            Text(isWeight ? "g" : "ml" ).tag(false)
                            Text(isWeight ? "oz" : "fl oz").tag(true)
                        }
                        .pickerStyle(.segmented)
                    }
                    .modifier( TextFieldMod(isInvalid: false) )
                    
                    Text("The coefficient will be calculated automatically")
                        .font(.caption)
                        .foregroundStyle(Color.textTertiary)
                }
                
                // MARK: Save Button
                VStack {
                    
                    if title.isEmpty || shortTitle.isEmpty || (inputKoefficient ?? 0) <= 0 {
                        Text("Fill in all fields to save")
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading) 
                    }
                    
                    Button("Save") {
                        showDuplicateError = false
                        
                        guard !viewModel.isMeasureDuplicate(title: title, shortTitle: shortTitle, excludingID: isNew ? nil : measure?.id  )
                        else {
                            showDuplicateError = true
                            return
                        }
                        
                        //MARK: if measure is Imperial, need to recalculate it
                        let calculatedKoefficient = viewModel.convertToKoefficient(input: inputKoefficient ?? 0, isWeight: isWeight, isImperial: isImperial)
                        
                        //MARK: Reuse of same button to save new or update existing measure
                        if isNew {
                            viewModel.saveMeasure(title: title, shortTitle: shortTitle, koefficient: calculatedKoefficient, isWeight: isWeight, isImperial: isImperial)
                            dismiss()
                        } else {
                            viewModel.updateMeasure(measure!, title: title, shortTitle: shortTitle, koefficient: calculatedKoefficient, isImperial: isImperial, isWeight: isWeight)
                            dismiss()
                        }
                    }
                    .modifier(ButtonMod(color: .blue, isEnabled: !title.isEmpty && !shortTitle.isEmpty && (inputKoefficient ?? 0) > 0 ))
                }
                
                if showDuplicateError {
                    Text("This Measure already exists. \nIf you cannot find it, turn on Imperial measures")
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
                    isWeight = measure?.isWeight ?? true
                    isImperial = measure?.isImperial ?? false
                    inputKoefficient = measure?.displayImperialKoefficient
                }
            }
            
            Spacer()
        }
    }
    
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Measure.self, Ingredient.self, configurations: config)
//    let vm = CalcViewModel()
//    return NavigationStack {
//        AddMeasureView(isNew: true, measure: nil)
//    }
//    .environment(vm)
//    .modelContainer(container)
//}
