//
//  Formatters.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-20.
//

import Foundation


func setDateMMYY(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.dateFormat = "LLLL yyyy"
    let dateString = formatter.string(from: date)
    return dateString.capitalized
}

func setDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.dateStyle = .medium
    let dateString = formatter.string(from: date)
    return dateString
}

func setDecimalFormatter(currencySymbol: String) -> NumberFormatter {
//    let currencys = Locale.isoCurrencyCodes
//    print(currencys)
    let formatter = NumberFormatter()
    formatter.locale = .current
    formatter.numberStyle = .currency
    print(formatter.currencySymbol ?? "-")
    //formatter.currencyCode = "RUB"
    formatter.currencySymbol = currencySymbol
    formatter.maximumFractionDigits = 2
    //formatter.groupingSeparator = ""
    return formatter
}

func getMonthFrom(date: Date) -> Int? {
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.month], from: date)
    let month = components.month
    return month
}

func getYearFrom(date: Date) -> Int? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: date)
    let year = components.year
    return year
}
