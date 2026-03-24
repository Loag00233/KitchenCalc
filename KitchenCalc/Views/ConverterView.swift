import SwiftUI

struct ConverterView: View {
    @State private var inputValue: String = "920"
    @State private var outputValue: String = "1000"
    @State private var inputUnit: String = "g"
    @State private var outputUnit: String = "ml"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.large) {
                    
                    // MARK: - Product Card
                    Button {
                        // TODO: open ProductSheetView
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                                Text("Sunflower Oil")
                                    .font(.productTitle)
                                    .foregroundStyle(Color.textPrimary)
                                Text("920 kg/m\u{00B3}")
                                    .font(.productSubtitle)
                                    .foregroundStyle(Color.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.textTertiary)
                        }
                        .padding(Spacing.large)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
                    }
                    
                    // MARK: - Converter Card
                    VStack(spacing: 0) {
                        
                        // Input row
                        HStack {
                            unitButton(title: inputUnit)
                            Spacer()
                            Text(inputValue)
                                .font(.converterValue)
                                .foregroundStyle(Color.accent)
                        }
                        .padding(.horizontal, Spacing.large)
                        .padding(.vertical, Spacing.medium)
                        
                        // Swap button
                        HStack {
                            Spacer()
                            Button {
                                swap(&inputUnit, &outputUnit)
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.swapIcon)
                                    .foregroundStyle(Color.textSecondary)
                                    .padding(Spacing.small)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                            Spacer()
                        }
                        
                        // Output row
                        HStack {
                            unitButton(title: outputUnit)
                            Spacer()
                            Text(outputValue)
                                .font(.converterValue)
                                .foregroundStyle(Color.textPrimary)
                        }
                        .padding(.horizontal, Spacing.large)
                        .padding(.vertical, Spacing.medium)
                    }
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
                    
                    // MARK: - History Panel
                    VStack(alignment: .leading, spacing: Spacing.medium) {
                        HStack {
                            Text("HISTORY")
                                .font(.sectionHeader)
                                .foregroundStyle(Color.textSecondary)
                            Spacer()
                            Button("All") {
                                // TODO: open HistorySheetView
                            }
                            .font(.bodyRegular)
                            Image(systemName: "arrow.right")
                                .font(.chevronMedium)
                        }
                        .foregroundStyle(Color.accent)
                        
                        historyRow(product: "Oil",   from: "920 g", to: "1000 ml")
                        Divider()
                        historyRow(product: "Flour", from: "500 g", to: "833 ml")
                    }
                    .padding(Spacing.large)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Radius.card))
                }
                .padding(.horizontal, Spacing.large)
            }
            .navigationTitle("Converter")
            .background { Color.appBackground.ignoresSafeArea() }
        }
    }
    
    // MARK: - Components
     
    private func unitButton(title: String) -> some View {
        HStack(spacing: Spacing.extraSmall) {
            Text(title)
                .font(.unitLabel)
            Image(systemName: "chevron.down")
                .font(.chevronSmall)
        }
        .foregroundStyle(Color.textPrimary)
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(.ultraThinMaterial, in: Capsule())
    }
    
    private func historyRow(product: String, from: String, to: String) -> some View {
        HStack {
            Text(product)
                .foregroundStyle(Color.textSecondary)
            Image(systemName: "arrow.right")
                .font(.historyArrow)
                .foregroundStyle(Color.textTertiary)
            Text("\(from) = \(to)")
                .foregroundStyle(Color.textPrimary)
        }
        .font(.bodyRegular)
    }
}

#Preview {
    ConverterView()
}
