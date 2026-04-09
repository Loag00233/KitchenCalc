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
    
    var displayImperialKoefficient: Double {
        guard isImperial else { return koefficient }
        return isWeight ? koefficient / 28.3495 : koefficient / 29.5735
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
        Measure(title: "measureTeaSpoon5", shortTitle: "measureTspShort", koefficient: 5, isWeight: true, isImperial: true, isCustom: false),
        Measure(title: "measureTableSpoon15", shortTitle: "measureTbspShort", koefficient: 15, isWeight: true, isImperial: true, isCustom: false),
        Measure(title: "measureCup240", shortTitle: "measureCupShort", koefficient: 240, isWeight: true, isImperial: true, isCustom: false),
        Measure(title: "measureOunce", shortTitle: "measureOunceShort", koefficient: 28.3495, isWeight: true, isImperial: true, isCustom: false),
        Measure(title: "measurePound", shortTitle: "measurePoundShort", koefficient: 453.592, isWeight: true, isImperial: true, isCustom: false),
        Measure(title: "fluidOunce", shortTitle: "measureFluidOunceShort", koefficient: 29.5735, isWeight: false, isImperial: true, isCustom: false),
        Measure(title: "measurePint", shortTitle: "measurePintShort", koefficient: 473.176, isWeight: false, isImperial: true, isCustom: false),
        // Метрические
        Measure(title: "measureGram", shortTitle: "measureGramShort", koefficient: 1, isWeight: true, isCustom: false), // main calculation characteristic
        Measure(title: "measureKillogram", shortTitle: "measureKilogramShort", koefficient: 1000, isWeight: true, isCustom: false),
        Measure(title: "measureMillilitre", shortTitle: "measureMillilitreShort", koefficient: 1, isWeight: false, isCustom: false),
        Measure(title: "measureLitre", shortTitle: "measureLitreShort", koefficient: 1000, isWeight: false, isCustom: false),
    ]
}
