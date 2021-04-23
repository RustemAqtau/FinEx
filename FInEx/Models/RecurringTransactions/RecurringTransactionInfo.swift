//
//  RecurringTransactionInfo.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-18.
//

import Foundation

struct RecurringTransactionInfo {
    let startDate: Date
    let nextAddingDate: Date
    let amount: NSDecimalNumber
    let note: String
    let periodicity: String
    let type: TransactionType
    let category: String
}
