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
        HStack(spacing: Spacing.medium) {
            Text(viewModel.ingredientTitle)
                .foregroundStyle(Color.textSecondary)
                .bold()
            
            Spacer()
            
            Text("\(viewModel.result.inValue.formatted(.number.precision(.fractionLength(0...2)))) \(viewModel.inMeasureTitle)")
                .lineLimit(1)
            
            Image(systemName: "arrow.right")
                .foregroundStyle(Color.textSecondary)
            
            Text("\(viewModel.result.value.formatted(.number.precision(.fractionLength(0...2)))) \(viewModel.outMeasureTitle)")
                .bold()
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
