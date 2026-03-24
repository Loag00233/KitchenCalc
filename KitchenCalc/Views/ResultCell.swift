//
//  ResultCell.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 19.02.2026.
//

import SwiftUI

struct ResultCell: View {
    @State var viewModel: ResultCellViewModel
    var body: some View {
            HStack(spacing: 40) {
                Text("Тупа ингредиент пока")
                    .foregroundStyle(.secondary)
                    .bold()
                
                Text("\(viewModel.result.inValue.formatted(.number.precision(.fractionLength(0...2)))) \(viewModel.inMeasureTitle)")
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                
                Text("\(viewModel.result.value.formatted(.number.precision(.fractionLength(0...2)))) \(viewModel.outMeasureTitle)")
                    .bold()
            }
    }
}

//#Preview {
//    ResultCell(result: .init(id: UUID().uuidString, inValue: 12.32, inMeasureTitle: "L", ingredientTitle: "Соль", outMeasureTitle: "KG", value: 12.89 ))
//}
