//
//  RecurringTransaction.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-18.
//

import CoreData
import SwiftUI

extension RecurringTransaction {
    
    func updateNextAddingDate(context: NSManagedObjectContext) {
        let calendar = Calendar.current
        let lastAddedDate: Date = self.nextAddingDate!
        
        switch self.periodicity {
        case Periodicity.Month.rawValue:
            self.nextAddingDate = calendar.date(byAdding: .month, value: 1, to: lastAddedDate)!
        case Periodicity.Quarter.rawValue:
            self.nextAddingDate = calendar.date(byAdding: .month, value: 3, to: lastAddedDate)!
        case Periodicity.TwoWeeks.rawValue:
            self.nextAddingDate = calendar.date(byAdding: .day, value: 14, to: lastAddedDate)!
        case Periodicity.Year.rawValue:
            self.nextAddingDate = calendar.date(byAdding: .year, value: 1, to: lastAddedDate)!
        default:
            self.nextAddingDate = calendar.date(byAdding: .month, value: 1, to: lastAddedDate)!
        }
        let nextAddingMonth = getMonthFrom(date: self.nextAddingDate!)!
        let nextAddingYear = getYearFrom(date: self.nextAddingDate!)!
        self.nextAddingMonth = Int32(nextAddingMonth)
        self.nextAddingYear = Int32(nextAddingYear)
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Could not save context")
            }
        }
        
    }
    
    var typeInfo: TransactionType {
        let type = getType(context: self.managedObjectContext!)
        return type
    }
    
    func getType(context: NSManagedObjectContext) -> TransactionType {
        var fetchedTypes: [TransactionType] = []
        let predicate = NSPredicate(format: "recurringTransaction = %@", argumentArray: [self])
        let request = TransactionType.fetchRequest(predicate: predicate)
        do {
            let fetchedResult = try context.fetch(request)
            fetchedTypes = fetchedResult
        } catch {
            print("Fetch fail: TransactionType. Error: \(error.localizedDescription)")
        }
        return fetchedTypes.first!
    }
    
    func delete(context: NSManagedObjectContext) {
        context.delete(self)
        do {
            try context.save()
            print("Context saved")
        } catch {
            print("Could not save context")
        }
    }
    
    static func update(from info: RecurringTransactionInfo, context: NSManagedObjectContext) {
        let nextAddingMonth = getMonthFrom(date: info.nextAddingDate)!
        let nextAddingYear = getYearFrom(date: info.nextAddingDate)!
        
        let transaction = RecurringTransaction(context: context)
        transaction.amount = info.amount
        transaction.note = info.note
        transaction.periodicity = info.periodicity
        transaction.startDate = info.startDate
        transaction.type = info.type
        transaction.category = info.type.category
        transaction.nextAddingDate = info.nextAddingDate
        transaction.nextAddingMonth = Int32(nextAddingMonth)
        transaction.nextAddingYear = Int32(nextAddingYear)
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Could not save context")
            }
        }
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<RecurringTransaction> {
        let request = NSFetchRequest<RecurringTransaction>(entityName: "RecurringTransaction")
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        request.predicate = predicate
        return request
    }
}

