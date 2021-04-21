//
//  Formatters+Enums.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

enum Periodicity: String, CaseIterable {
    
    typealias RawValue = String
    
    case TwoWeeks = "Every two weeks"
    case Month = "Every month"
    case Quarter = "Every third month"
    case Year = "Every year"
    
}

enum GradientColors {
    typealias RawValue = LinearGradient
    
    static let Expense = LinearGradient(gradient: Gradient(colors: [Color("ExpensesColor"), Color("ExpensesColor2")]), startPoint: .bottomTrailing, endPoint: .topLeading)
    static let Income = LinearGradient(gradient: Gradient(colors: [Color("BalanceColor"), Color("NewBalanceColor")]), startPoint: .bottomTrailing, endPoint: .topLeading)
    static let Saving = LinearGradient(gradient: Gradient(colors: [Color("IncomeColor"), Color("SavingsColor")]), startPoint: .bottomTrailing, endPoint: .topLeading)
    
    static let Home = LinearGradient(gradient: Gradient(colors: [Color("HomeButtonGradient1"), Color("HomeButtonGradient2")]), startPoint: .bottomTrailing, endPoint: .topLeading)
    
}

enum Categories: CaseIterable {
    static let Income = "Income"
    static let Expense = "Expense"
    static let Saving = "Saving"
}



enum ExpenseSubCategories: String, CaseIterable {
    case Housing = "Housing"
    case Entertainment = "Entertainment"
    case FoodAndDrinks = "Food & Drinks"
    case Bills = "Bills"
    case Transportation = "Transportation"
    case Health = "Health"
    case Subscriptions = "Subscriptions"
    case Insurance = "Insurance"
    case Travel = "Travel"
    case Shopping = "Shopping"
}

enum SvaingSubCategories: String, CaseIterable {
    case LongTerm = "Long Term"
    case ShortTerm = "Short Term"
}

enum CategoryIcons {
    typealias RawValue = [String]
    
    static let first = ["person.3", "person.crop.square.fill.and.at.rectangle", "eyebrow", "mouth", "lungs", "face.dashed.fill", "person.fill.viewfinder", "figure.walk", "figure.wave", "figure.stand.line.dotted.figure.stand", "hands.sparkles.fill"]
    static let second = ["drop", "flame", "bolt", "hare", "tortoise", "ladybug", "leaf", "heart.text.square", "heart", "bandage.fill", "cross.case.fill", "bed.double", "pills"]
    static let third = ["waveform.path.ecg", "staroflife", "cross", "bag.fill", "cart", "creditcard.fill", "giftcard.fill", "dollarsign.circle.fill", "bitcoinsign.circle.fill"]
}


func setDate(date: Date) -> String {
    let currentDate = date
    let format = DateFormatter()
    format.dateFormat = "MM.dd.yyyy"
    let dateString = format.string(from: currentDate)
    return dateString
}

func setDecimalFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = .current
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    //formatter.groupingSeparator = ""
    return formatter
}
