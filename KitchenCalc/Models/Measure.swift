//
//  Measure.swift
//  KitchenCalc
//
//  Created by Ivan Ivashin on 15.02.2026.
//

import Foundation
import SwiftData

@Model
class Measure: Hashable {
    @Attribute(.unique) var id: UUID
    var title: String
    var shortTitle: String
    var koefficient: Double
    var isWeight: Bool
    var isImperial: Bool
    var isCustom: Bool
    
    var displayTitle: String {
        isCustom ? title : String(localized: String.LocalizationValue(title))
    }
    
    var displayShortTitle: String {
        isCustom ? shortTitle : String(localized: String.LocalizationValue(shortTitle))
    }
    
    init(id: UUID = UUID(),
         title: String,
         shortTitle: String,
         koefficient: Double,
         isWeight: Bool,
         isImperial: Bool = false,
         isCustom: Bool = false) {
        self.id = id
        self.title = title
        self.shortTitle = shortTitle
        self.koefficient = koefficient
        self.isWeight = isWeight
        self.isImperial = isImperial
        self.isCustom = isCustom
    }
    
    static var mockDataMeasure: [Measure] = [
        // Имперские
        Measure(title: "measure_ounce", shortTitle: "measure_ounce_short", koefficient: 0.0283495, isWeight: true, isImperial: true, isCustom: false),
        Measure(title: "measure_pound", shortTitle: "measure_pound_short", koefficient: 0.453592, isWeight: true, isImperial: true, isCustom: false),
        Measure(title: "fluid_ounce", shortTitle: "measure_fluid_ounce_short", koefficient: 0.0000295735, isWeight: false, isImperial: true, isCustom: false),
        Measure(title: "measure_pint", shortTitle: "measure_pint_short", koefficient: 0.000473176, isWeight: false, isImperial: true, isCustom: false),
        // Метрические
        Measure(title: "measure_gram", shortTitle: "measure_gram_short", koefficient: 0.001, isWeight: true, isCustom: false),
        Measure(title: "measure_killogram", shortTitle: "measure_kilogram_short", koefficient: 1, isWeight: true, isCustom: false),
        Measure(title: "measure_millilitre", shortTitle: "measure_millilitre_short", koefficient: 0.000001, isWeight: false, isCustom: false),
        Measure(title: "measure_litre", shortTitle: "measure_litre_short", koefficient: 0.001, isWeight: false, isCustom: false),
        Measure(title: "measure_tea_spoon_5", shortTitle: "measure_tsp_short", koefficient: 0.000005, isWeight: false, isCustom: false),
        Measure(title: "measure_table_spoon_15", shortTitle: "measure_tbsp_short", koefficient: 0.000015, isWeight: false, isCustom: false),
        Measure(title: "measure_cup_250", shortTitle: "measure_cup_short", koefficient: 0.00025, isWeight: false, isCustom: false),
    ]
}
