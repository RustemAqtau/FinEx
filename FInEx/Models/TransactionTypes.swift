//
//  TransactionTypes.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-11.
//

import CoreData

extension TransactionType {
    
    static func update(from info: TransactionTypesInfo, context: NSManagedObjectContext) {
        
        let transactionType = TransactionType(context: context)
        
        
        do {
            try context.save()
            print("Context saved")
        } catch {
            print("Could not save context")
        }
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<TransactionType> {
        let request = NSFetchRequest<TransactionType>(entityName: "TransactionTypes")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        return request
    }
}
