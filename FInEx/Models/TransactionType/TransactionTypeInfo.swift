//
//  TransactionTypesInfo.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-11.
//

import Foundation

struct TransactionTypeInfo {
     let category: String
     let subCategory: String?
     let name: String
     let imageName: String
     let colorName: String
     let isHidden: Bool
    
    init(category: String, subCategory: String?, name: String, imageName: String, colorName: String, isHidden: Bool) {
        self.category = category
        self.subCategory = subCategory
        self.name = name
        self.imageName = imageName
        self.colorName = colorName
        self.isHidden = isHidden
    }
}
