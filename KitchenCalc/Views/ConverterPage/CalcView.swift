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
                    Group {
                        if let ingredient = viewModel.selectedIngredient {
                            Text(ingredient.title)
                        } else {
                            Text("Select product")
                        }
                    }
                    .font(.viewTitle)
                    .foregroundStyle(Color.textPrimary)
                    if let density = viewModel.selectedIngredient?.density {
                        Text("\(Double(density).formatted(.number.precision(.fractionLength(0...2)) )) g/ml")
                            .font(.bodyRegular)
                            .foregroundStyle(Color.textSecondary)
                    }
                    Spacer()
                    viewModel.selectedIngredient?.confidence.badge
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
                ProductSheetView()
            }
            
            
            VStack(spacing: 0) {
                
                // MARK: Входные значения
                HStack {
                    TextField("Value", value: $viewModel.inValue, format: .number.grouping(.never))
                        .font(.converterValue)
                        .foregroundStyle(Color.accent)
                        .keyboardType(.decimalPad)
                    Spacer()
                    unitPicker(selection: $viewModel.inMeasure)
                }
                .padding(.horizontal, Spacing.large)
                .padding(.vertical, Spacing.medium)
                
                ZStack {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.25))
                        .frame(height: 1)
                    Button {
                        viewModel.swapMeasures()
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
                    
                    Text((viewModel.outValue ?? 0)
                        .formatted(.number.precision(.fractionLength(0...2)).grouping(.never) ))
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
                    .background(Color.white.opacity(0.2), in: Capsule())
                    .padding(.horizontal, Spacing.large)
                    .padding(.bottom, Spacing.small)
                }
                
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
            .padding(.horizontal, Spacing.medium)
            
            // MARK: Save Button
            Button {
                viewModel.saveSolveResult()
            } label: {
                Text("Save result")
                    .modifier(ButtonMod(color: .accent, isEnabled: viewModel.canSaveResult))
            }
            .disabled(!viewModel.canSaveResult)
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
            ForEach(viewModel.filteredMeasures) { measure in
                Text(measure.displayTitle).tag(measure)
            }
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(.ultraThinMaterial, in: Capsule())
    }
    
}

