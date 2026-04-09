//
//  CalcView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 14.02.2026.
//

import SwiftUI

struct CalcView: View {
    
    @Environment(CalcResultVM.self) private var calcResultVM
    @Environment(IngredientsVM.self) private var ingredientsVM
    @Environment(MeasuresVM.self) private var measuresVM
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var showIngredientSheet = false
    
    var body: some View {
        NavigationStack {
            Group {
                if verticalSizeClass == .compact {
                    HStack(alignment: .top, spacing: 0) {
                        controlsBlock()
                        historyBlock()
                    }
                } else {
                    VStack(spacing: 0) {
                        controlsBlock()
                        historyBlock()
                    }
                }
            }
            .navigationTitle("Converter")
            .background { Color.appBackground.ignoresSafeArea() }
            .hideKeyboardOnTap()
            .onChange(of: calcResultVM.inValue) { calcResultVM.solve(inValue: calcResultVM.inValue, inMeasure: measuresVM.inMeasure, outMeasure: measuresVM.outMeasure, ingredient: ingredientsVM.selectedIngredient) }
            .onChange(of: measuresVM.inMeasure) { calcResultVM.solve(inValue: calcResultVM.inValue, inMeasure: measuresVM.inMeasure, outMeasure: measuresVM.outMeasure, ingredient: ingredientsVM.selectedIngredient) }
            .onChange(of: measuresVM.outMeasure) { calcResultVM.solve(inValue: calcResultVM.inValue, inMeasure: measuresVM.inMeasure, outMeasure: measuresVM.outMeasure, ingredient: ingredientsVM.selectedIngredient) }
            .onChange(of: ingredientsVM.selectedIngredient) { calcResultVM.solve(inValue: calcResultVM.inValue, inMeasure: measuresVM.inMeasure, outMeasure: measuresVM.outMeasure, ingredient: ingredientsVM.selectedIngredient) }
        }
    }
    
    @ViewBuilder private func controlsBlock() -> some View {
        @Bindable var calcResultVM = calcResultVM
        @Bindable var measuresVM = measuresVM
        
        VStack(spacing: Spacing.large) {
            
            Button {
                showIngredientSheet = true
            } label: {
                HStack(spacing: Spacing.extraSmall) {
                    Group {
                        if let ingredient = ingredientsVM.selectedIngredient {
                            Text(ingredient.title)
                        } else {
                            Text("Select Ingredient")
                        }
                    }
                    .font(.viewTitle)
                    .foregroundStyle(Color.textPrimary)
                    if let density = ingredientsVM.selectedIngredient?.density {
                        Text("\(Double(density).formatted(.number.precision(.fractionLength(0...2)) )) g/ml")
                            .font(.bodyRegular)
                            .foregroundStyle(Color.textSecondary)
                    }
                    Spacer()
                    ingredientsVM.selectedIngredient?.confidence.badge
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.textTertiary)
                }
                .padding(Spacing.large)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.card)
                        .stroke(Color.accent.opacity(0.4), lineWidth: 1)
                )
                .contentShape(RoundedRectangle(cornerRadius: Radius.card))
            }
            .padding(.horizontal, Spacing.medium)
            
            .sheet(isPresented: $showIngredientSheet) {
                IngredientSheetView()
            }
            
            
            VStack(spacing: 0) {
                
                // MARK: Входные значения
                HStack {
                    TextField("Value", value: $calcResultVM.inValue, format: .number.grouping(.never))
                        .font(.converterValue)
                        .foregroundStyle(Color.accent)
                        .keyboardType(.decimalPad)
                    Spacer()
                    unitPicker(selection: $measuresVM.inMeasure)
                }
                .padding(.horizontal, Spacing.large)
                .padding(.vertical, Spacing.medium)
                
                ZStack {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.25))
                        .frame(height: 1)
                    Button {
                        measuresVM.swapMeasures()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(Color.textSecondary)
                            .padding(Spacing.small)
                            .background(.ultraThinMaterial, in: Circle())
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // MARK: Рассчетные значения
                HStack {
                    
                    Text((calcResultVM.outValue ?? 0)
                        .formatted(.number.precision(.fractionLength(0...2)).grouping(.never) ))
                    .font(.converterValue)
                    Spacer()
                    unitPicker(selection: $measuresVM.outMeasure)
                }
                .padding(.horizontal, Spacing.large)
                .padding(.vertical, Spacing.medium)
                .frame(maxWidth: .infinity)
                
                if let hint = ingredientsVM.selectedIngredient?.confidence.hint {
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                        Text(hint)
                            .font(.caption)
                    }
                    .foregroundStyle(ingredientsVM.selectedIngredient?.confidence.colorBadge ?? .orange)
                    .background(Color.primary.opacity(0.2), in: Capsule())
                    .padding(.horizontal, Spacing.large)
                    .padding(.bottom, Spacing.small)
                }
                
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
            .padding(.horizontal, Spacing.medium)
            
            // MARK: Save Button
            Button {
                calcResultVM.saveSolveResult(inValue: calcResultVM.inValue, inMeasure: measuresVM.inMeasure, outMeasure: measuresVM.outMeasure, ingredient: ingredientsVM.selectedIngredient)
            } label: {
                Text("Save result")
                    .modifier(ButtonMod(color: .accent, isEnabled: calcResultVM.canSaveResult(ingredient: ingredientsVM.selectedIngredient)))
            }
            .disabled(!calcResultVM.canSaveResult(ingredient: ingredientsVM.selectedIngredient) )
            .padding(.horizontal, Spacing.medium)
        }
        .padding(.bottom, Spacing.large)
    }
    
    @ViewBuilder private func historyBlock() -> some View {
        
        if calcResultVM.solveResults.isEmpty {
            ContentUnavailableView(
                "No results yet",
                systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                description: Text("Save a calculation to see it here")
            )
        } else {
            List(calcResultVM.solveResults) { result in
                ResultCell(result: result)
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            calcResultVM.deleteSolveResult(result)
                        }
                    }
                    .contextMenu {
                        Button {
                            let cellText = result.ingredient + " " + result.inValue.formatted() + " " + result.inMeasure + "→" + result.value.formatted() + " " + result.outMeasure
                            UIPasteboard.general.string = cellText
                        } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }
                
                    .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.immediately)
        }
        
    }
    
    
    private func unitPicker(selection: Binding<Measure>) -> some View {
        Picker("", selection: selection) {
            ForEach(measuresVM.filteredMeasures) { measure in
                Text(measure.displayTitle).tag(measure)
            }
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(.ultraThinMaterial, in: Capsule())
    }
    
}

