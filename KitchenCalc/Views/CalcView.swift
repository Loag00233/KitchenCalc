//
//  CalcView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 14.02.2026.
//

import SwiftUI

struct CalcView: View {
    @Environment(CalcViewModel.self) private var viewModel
    @State private var showProductSheet = false
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
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
            .onChange(of: viewModel.inValue) { viewModel.solve() }
            .onChange(of: viewModel.inMeasure) { viewModel.solve() }
            .onChange(of: viewModel.outMeasure) { viewModel.solve() }
            .onChange(of: viewModel.selectedIngredient) { viewModel.solve() }
        }
    }
    
    @ViewBuilder private func controlsBlock() -> some View {
        @Bindable var viewModel = viewModel

        VStack(spacing: Spacing.large) {
            
            Button {
                showProductSheet = true
            } label: {
                HStack(spacing: Spacing.extraSmall) {
                    Text(viewModel.selectedIngredient?.title ?? "Select product")
                        .font(.productTitle)
                        .foregroundStyle(Color.textPrimary)
                    if let density = viewModel.selectedIngredient?.density {
                        Text("\(Int(density)) kg/m³")
                            .font(.bodyRegular)
                            .foregroundStyle(Color.textSecondary)
                    }
                    Spacer()
                    viewModel.selectedIngredient?.badge
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
            
            .sheet(isPresented: $showProductSheet) {
                ProductSheetView(selectedIngredient: $viewModel.selectedIngredient)
            }
            
            
            VStack(spacing: 0) {
                
                // Входные значения
                HStack {
                    TextField("Value", value: $viewModel.inValue, format: .number)
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
                
                if let hint = viewModel.selectedIngredient?.confidence.hint {
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                        Text(hint)
                            .font(.caption)
                    }
                    .foregroundStyle(viewModel.selectedIngredient?.confidence.colorBadge ?? .orange)
                    .background(Color.black.opacity(0.2), in: Capsule())
                    .padding(.horizontal, Spacing.large)
                    .padding(.bottom, Spacing.small)
                }
                
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
            .padding(.horizontal, Spacing.medium)
            
            Button {
                viewModel.saveSolveResult()
            } label: {
                Text("Save result")
                    .modifier(ButtonMod(color: .accent))
            }
            .padding(.horizontal, Spacing.medium)
        }
        .padding(.bottom, Spacing.large)
    }
    
    @ViewBuilder private func historyBlock() -> some View {
        
        if viewModel.solveResults.isEmpty {
            ContentUnavailableView(
                "No results yet",
                systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                description: Text("Save a calculation to see it here")
            )
        } else {
            List(viewModel.solveResults) { result in
                ResultCell(result: result)
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            viewModel.deleteSolveResult(result)
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
            ForEach(viewModel.filteredMeasures) { measure in
                Text(measure.displayTitle).tag(measure)
            }
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(.ultraThinMaterial, in: Capsule())
    }
    
}

