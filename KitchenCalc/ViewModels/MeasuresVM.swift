//
//  MeasuresVM.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 09.04.2026.
//

import Foundation
import SwiftData

@Observable
class MeasuresVM {
    
    var inMeasure: Measure = Measure(title: "Choose input measure", shortTitle: "", koefficient: 0, isWeight: false)
    var outMeasure: Measure = Measure(title: "Choose output measure", shortTitle: "", koefficient: 0, isWeight: false)
    var measures: [Measure] = []
    var showImperial: Bool = UserDefaults.standard.bool(forKey: "showImperial") {
        didSet {UserDefaults.standard.set(showImperial, forKey: "showImperial")}
    }
    var filteredMeasures: [Measure] {showImperial ? self.measures : measures.filter { !$0.isImperial }}
    var customMeasures: [Measure] { measures.filter{$0.isCustom} }
    private var modelContext: ModelContext?
    
    func setup(_ context: ModelContext) {
        self.modelContext = context
        fetchMeasures()
        if let defaultIn = filteredMeasures.first { inMeasure = defaultIn }
        if let defaultOut = filteredMeasures.last { outMeasure = defaultOut }
    }
    
    private func save() {
        try? modelContext?.save()
    }
    
    func saveMeasure(title: String, shortTitle: String, koefficient: Double, isWeight: Bool, isImperial: Bool) {
        guard !title.isEmpty && !shortTitle.isEmpty else { return }
        guard koefficient > 0 else { return }
        let measure = Measure(title: title, shortTitle: shortTitle, koefficient: koefficient, isWeight: isWeight, isImperial: isImperial, isCustom: true)
        self.modelContext?.insert(measure)
        fetchMeasures()
        save()
    }
    
    func updateMeasure(_ measure: Measure, title: String, shortTitle: String, koefficient: Double, isImperial: Bool, isWeight: Bool) {
        measure.title = title
        measure.shortTitle = shortTitle
        measure.koefficient = koefficient
        measure.isWeight = isWeight
        measure.isImperial = isImperial
        save()
    }
    
    func deleteMeasure(_ measure: Measure) {
        self.modelContext?.delete(measure)
        fetchMeasures()
        save()
    }
    
    func swapMeasures() {
        (inMeasure, outMeasure) = (outMeasure, inMeasure)
    }
    
    private func fetchMeasures() {
        measures = (try? self.modelContext?.fetch(FetchDescriptor<Measure>(sortBy: [SortDescriptor(\.koefficient)] ))) ?? []
    }
    
    func isMeasureDuplicate(title: String, shortTitle: String, excludingID: UUID? = nil) -> Bool {
        measures.contains{
            $0.id != excludingID &&
            (
                $0.displayTitle.lowercased() == title.lowercased() ||
                $0.displayShortTitle.lowercased() == shortTitle.lowercased()
            )
        }
    }
    
    func trimShortTitle(text: String) -> String {
        String(text.prefix(5))
    }
    
    func convertToKoefficient(input: Double, isWeight: Bool, isImperial: Bool) -> Double {
        if isWeight {
            return isImperial ? input * 28.3495 /* 1 ounce = 28.3495 g*/ : input /* thats gram*/
        } else {
            return isImperial ? input * 29.5735 /* 1 ml = 29.5735 fl oz */ : input  /*thats ml*/
        }
    }
    
}
