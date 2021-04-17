//
//  TransactionInfo.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-12.
//

import Foundation

struct TransactionInfo {
    let amount: NSDecimalNumber
    let date: Date
    let typeInfo: TransactionType
    let note: String
    init(amount: NSDecimalNumber, date: Date, typeInfo: TransactionType, note: String) {
        self.amount = amount
        self.date = date
        self.typeInfo = typeInfo
        self.note = note
    }
}
