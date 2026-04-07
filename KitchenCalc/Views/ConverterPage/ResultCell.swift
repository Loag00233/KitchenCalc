//
//  ResultCell.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 19.02.2026.
//

import SwiftUI

struct ResultCell: View {
    @State var result: SolveResult
    var body: some View {
        HStack(spacing: Spacing.medium) {
            Text(result.ingredient)
                .foregroundStyle(Color.textSecondary)
                .bold()
            
            Spacer()
            
            Text("\(result.inValue.formatted(.number.precision(.fractionLength(0...2)))) \(result.inMeasure)")
                .lineLimit(1)
            
            Image(systemName: "arrow.right")
                .foregroundStyle(Color.textSecondary)
            
            Text("\(result.value.formatted(.number.precision(.fractionLength(0...2)))) \(result.outMeasure)")
                .bold()
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
