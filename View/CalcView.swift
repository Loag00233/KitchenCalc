//
//  CalcView.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 14.02.2026.
//

import SwiftUI

struct CalcView: View {
    @State var viewModel = CalcViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Блок кода
            
            HStack {
                // Тип продукта
                Picker("", selection: $viewModel.selectedIngredient) {
                    ForEach(viewModel.ingredients, id: \.self) { ingred in
                        Text(ingred.title).tag(ingred as Ingredient?)
                    }
                }
                
                // Входные значения
                TextField("Enter the quantity", value: $viewModel.inValue, format: .number)
                    .keyboardType(.decimalPad)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .fill(.gray.opacity(0.4))
                    }
                
                Picker("", selection: $viewModel.inMeasure) {
                    ForEach(viewModel.listOfMeasure) { measure in
                        Text(measure.title).tag(measure)
                    }
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
            }
            
            // Блок результата
            
            HStack {
                
                Text("Equals")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text((viewModel.outValue ?? 0)
                    .formatted(.number.precision(.fractionLength(0...2))))
                .font(.system(size: 32))
                
                Spacer()
                
                Picker("", selection: $viewModel.outMeasure) {
                    ForEach(viewModel.listOfMeasure) { measure in
                        Text(measure.title)
                            .tag(measure)
                    }
                }
                .fixedSize()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
            }
            
            // Кнопки
            
            HStack(spacing: 16) {
                Button("Calculate") {
                    viewModel.solve()
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.blue)
                }
                .alert("Fill the quantity", isPresented: $viewModel.showError) {}
                
                Button("Save") {
                    viewModel.remember()
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.green)
                }
            }
            .foregroundStyle(.white)
            
            // Сохранённые расчёты
            
            Text("Saved Calculations")
                .font(.headline)
            
            if viewModel.solveResults.isEmpty {
                // Placeholder когда список пуст
                Text("No saved calculations")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
            } else {
                List(viewModel.solveResults) { result in
                    ResultCell(result: result)
                }
                .listStyle(.plain)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .fill(.gray)
                }
            }
        }
        .padding()
    }
}

#Preview {
    CalcView()
}

