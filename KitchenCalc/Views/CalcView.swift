//
//  CalcView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 14.02.2026.
//

import SwiftUI
import SwiftData

struct CalcView: View {
    @State var viewModel = CalcViewModel()
    @Environment(\.modelContext) private var modelContext
    @AppStorage("showImperial") private var showImperial = false
    @Query var ingredients: [Ingredient]
    @Query var solveResults: [SolveResult]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Button {
                        // TODO: open ProductSheetView
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                                Text(viewModel.selectedIngredient?.title ?? "Select product")
                                    .font(.productTitle)
                                    .foregroundStyle(Color.textPrimary)
                                if let density = viewModel.selectedIngredient?.density {
                                    Text("\(Int(density)) kg/m^3")
                                        .font(.productSubtitle)
                                        .foregroundStyle(Color.textSecondary)
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.textTertiary)
                        }
                        .padding(Spacing.large)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
                        .padding(.horizontal, Spacing.medium)

                    }
                    
                    
                    VStack(spacing: 0) {
                        
                        // Входные значения
                        HStack {
                            TextField("0", value: $viewModel.inValue, format: .number)
                                .font(.converterValue)
                                .foregroundStyle(Color.accent)
                            Spacer()
                            unitPicker(selection: $viewModel.inMeasure)
                        }
                        .padding(.horizontal, Spacing.large)
                        .padding(.vertical, Spacing.medium)
                        
                        Button {
                            viewModel.swapMeasures()
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.swapIcon)
                                .foregroundStyle(Color.textSecondary)
                                .padding(Spacing.small)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        
                        // Значения рассчета
                        
                        HStack {

                            Text((viewModel.outValue ?? 0)
                                .formatted(.number.precision(.fractionLength(0...2))))
                            .font(.converterValue)
                            Spacer()
                            unitPicker(selection: $viewModel.outMeasure)
                        }
                        .padding(.horizontal, Spacing.large)
                        .padding(.vertical, Spacing.medium)
                        .frame(maxWidth: .infinity)
                    }
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
                    .padding(.horizontal, Spacing.medium)
                    
                    
                    
                    // Панель истории
                    VStack(alignment: .leading, spacing: Spacing.medium) {
                        
                        HStack {
                            Text("HISTORY")
                                .font(.sectionHeader)
                                .foregroundStyle(Color.textSecondary)
                            Spacer()
                            Button("All") { /* TODO: open HistorySheetView */ }
                                .font(.bodyRegular)
                            Image(systemName: "arrow.right")
                                .font(.chevronMedium)
                        }
                        .foregroundStyle(Color.accent)
                        
                        ForEach(viewModel.solveResults.suffix(3)) { result in
                            historyRow(result: result)
                            Divider()
                        }
                        
                    }
                    .padding(Spacing.large)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
                    .padding(.horizontal, Spacing.medium)
                }
                .padding(4)
            }
            .navigationTitle("Converter")
            .background { Color.appBackground.ignoresSafeArea() }
            .onChange(of: viewModel.inValue) { viewModel.solve() }
            .onChange(of: viewModel.inMeasure) { viewModel.solve() }
            .onChange(of: viewModel.outMeasure) { viewModel.solve() }
            .onChange(of: viewModel.selectedIngredient) { viewModel.solve() }
            .onChange(of: showImperial) { viewModel.showImperial = showImperial }

        }
    }
    
    private func unitPicker(selection: Binding<Measure>) -> some View {
        Picker("", selection: selection) {
            ForEach(viewModel.listOfMeasure) { measure in
                Text(measure.title).tag(measure)
            }
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(.ultraThinMaterial, in: Capsule())
    }
    
    private func historyRow(result: SolveResult) -> some View {
        HStack {
            Text(result.ingredientTitleID)
                .foregroundStyle(Color.textSecondary)
            Image(systemName: "arrow.right")
                .font(.historyArrow)
                .foregroundStyle(Color.textTertiary)
            Text("\(result.inValue.formatted()) \(result.inMeasureID) = \(result.value.formatted()) \(result.outMeasureID)")
                .foregroundStyle(Color.textPrimary)
        }
        .font(.bodyRegular)
    }
}



#Preview {
    CalcView()
}

