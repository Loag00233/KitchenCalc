//
//  ResultCell.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 19.02.2026.
//

import SwiftUI

struct ResultCell: View {
    
    let result: SolveResult
    var body: some View {
            HStack(spacing: 40) {
                Text("\(result.ingredientTitle)")
                    .foregroundStyle(.secondary)
                    .bold()
                
                Text("\(result.inValue.formatted(.number.precision(.fractionLength(0...2)))) \(result.inMeasureTitle)")
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                
                Text("\(result.value.formatted(.number.precision(.fractionLength(0...2)))) \(result.outMeasureTitle)")
                    .bold()
            }
    }
}

#Preview {
    ResultCell(result: .init(id: UUID().uuidString, inValue: 12.32, inMeasureTitle: "L", ingredientTitle: "Соль", outMeasureTitle: "KG", value: 12.89 ))
}
