//
//  TransactionTypes.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-11.
//

import CoreData

extension TransactionType {
    
    var presentingColorName: String {
        return colorName ?? "TopGradient"
    }
    
    var presentingSubCategory: String {
        return subCategory ?? ""
    }
    
    var presentingImageName: String {
        return imageName ?? "questionmark"
    }
    
    var presentingName: String {
        return name ?? "Unknown"
    }
    
    func toggleIsHidden(context: NSManagedObjectContext) {
        self.isHidden.toggle()
        do {
            try context.save()
            print("Context saved")
        } catch {
            print("Could not save context")
        }
    }
    
    static func getType(by info: TransactionTypeInfo, context: NSManagedObjectContext) -> TransactionType? {
        var type: TransactionType? = TransactionType()
        let predicate = NSPredicate(format: "(category = %@ AND subCategory = %@) AND name = %@", argumentArray: [info.category, info.subCategory, info.name])
        let request = TransactionType.fetchRequest(predicate: predicate)
        do {
            let fetchedResult = try context.fetch(request)
            type = fetchedResult.first
        } catch {
            print("Error fetching context: \(error)")
        }
        return type
    }
    
    static func update(from info: TransactionTypeInfo, context: NSManagedObjectContext) {
        
        let transactionType = TransactionType(context: context)
        transactionType.category = info.category
        transactionType.subCategory = info.subCategory
        transactionType.name = info.name
        transactionType.imageName = info.imageName
        transactionType.colorName = info.colorName
        transactionType.isHidden = false
        do {
            try context.save()
            print("Context saved")
        } catch {
            print("Could not save context")
        }
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<TransactionType> {
        let request = NSFetchRequest<TransactionType>(entityName: "TransactionType")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        return request
    }
}
