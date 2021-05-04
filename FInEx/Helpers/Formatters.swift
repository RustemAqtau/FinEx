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

func setDecimalFormatter(currencySymbol: String, fractionDigitsNumber: Int) -> NumberFormatter {

    let formatter = NumberFormatter()
    formatter.locale = .current
    formatter.numberStyle = .currency
    formatter.currencySymbol = currencySymbol
    formatter.maximumFractionDigits = fractionDigitsNumber
    return formatter
}

func getHourFrom(date: Date) -> Int? {
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour], from: date)
    let hour = components.hour
    return hour
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

func getFirstDayOfmonth(date: Date) -> Date {
    let calendar = Calendar.current
    let year = getYearFrom(date: date)
    let month = getMonthFrom(date: date)
    let startComponents = DateComponents(year: year, month: month, day: 1)
    let startDate = calendar.date(from:startComponents)!
    return startDate
}

func getDateRange(for date: Date) -> ClosedRange<Date> {
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = components.year!
        let month = components.month!
        let startComponents = DateComponents(year: year, month: month, day: 1)
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: date)!
        print("Date range startComponents: \(calendar.date(from:startComponents)!)")
        print("Date range endOfMonth: \(endOfMonth)")
        return calendar.date(from:startComponents)!
            ...
            endOfMonth
    }()
    
    return dateRange
}
