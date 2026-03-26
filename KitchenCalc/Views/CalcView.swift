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
    @State private var showProductSheet = false
    @Environment(\.modelContext) private var modelContext
    @AppStorage("showImperial") private var showImperial = false
    @Query var ingredients: [Ingredient]
    @Query var solveResults: [SolveResult]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.large) {
                    
                    Button {
                        showProductSheet = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                                Text(viewModel.selectedIngredient?.title ?? "Select product")
                                    .font(.productTitle)
                                    .foregroundStyle(Color.textPrimary)
                                if let density = viewModel.selectedIngredient?.density {
                                    Text("\(Int(density)) kg/m^3")
                                        .font(.bodyRegular)
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
                    .sheet(isPresented: $showProductSheet) {
                          ProductSheetView(selectedIngredient: $viewModel.selectedIngredient)
                      }
                    
                    
                    VStack(spacing: 0) {
                        
                        // Входные значения
                        HStack {
                            TextField("0", value: $viewModel.inValue, format: .number)
                                .font(.converterValue)
                                .foregroundStyle(Color.accent)
                                .keyboardType(.decimalPad)
                            Spacer()
                            unitPicker(selection: $viewModel.inMeasure)
                        }
                        .padding(.horizontal, Spacing.large)
                        .padding(.vertical, Spacing.medium)
                        
                        ZStack {
                            Divider()
                            Button {
                                viewModel.swapMeasures()
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundStyle(Color.textSecondary)
                                    .padding(Spacing.small)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                        }
                        
                        // Рассчетные значения
                        
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
                    
                    Button {
                        viewModel.remember(context: modelContext)
                        
                    } label: {
                        Text("Save result")
                            .font(.bodyRegular)
                            .foregroundStyle(Color.accent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.medium)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
                            .padding(.horizontal, Spacing.medium)
                    }
                    
                }
                .padding(4)
                
                List(solveResults.reversed()) { result in
                    ResultCell(viewModel: ResultCellViewModel(result: result))
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                modelContext.delete(result)
                            }
                        }
                }
                .frame(height: 300)
                .scrollContentBackground(.hidden)
                
            }
            .navigationTitle("Converter")
            .scrollContentBackground(.hidden)
            .background { Color.appBackground.ignoresSafeArea() }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
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
    
}


#Preview {
    CalcView()
}

