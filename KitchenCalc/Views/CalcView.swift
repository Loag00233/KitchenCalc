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
    @Query var ingredients: [Ingredient]
    @Query var solveResults: [SolveResult]
    
    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: Карточка продукта
            
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
                
                // Блок результата
                
                HStack {
                    
                    Text((viewModel.outValue ?? 0)
                        .formatted(.number.precision(.fractionLength(0...2))))
                    .font(.system(size: 32))
                    
                    Spacer()
                    
                    unitPicker(selection: $viewModel.outMeasure)
                }
                .padding(.horizontal, Spacing.large)
                .padding(.vertical, Spacing.medium)
                .frame(maxWidth: .infinity)
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))

            
            
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


        }
        .padding(4)
    }
    
    private func unitPicker(selection: Binding<Measure>) -> some View {
        Picker("", selection: selection) {
            ForEach(viewModel.listOfMeasure) { measure in
                Text(measure.shortTitle).tag(measure)
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

