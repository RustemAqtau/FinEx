//
//  Transaction.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-12.
//

import CoreData

extension Transaction {
    
    var notePresentation: String {
        if let note = note {
            return note
        }
        return ""
    }
    
    var amountDecimal: NSDecimalNumber {
        if let amount = amount {
            return amount
        }
        return 0
    }
    
    var typeInfo: TransactionType {
        let type = getType(context: self.managedObjectContext!)
        return type
    }
    
    func getType(context: NSManagedObjectContext) -> TransactionType {
        var fetchedTypes: [TransactionType] = []
        let predicate = NSPredicate(format: "transaction = %@", argumentArray: [self])
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
    
    static func update(from recurringTransaction: RecurringTransaction, monthlyBudget: MonthlyBudget, context: NSManagedObjectContext) {
       
        let transaction = Transaction(context: context)
        transaction.monthlyBudget = monthlyBudget
        transaction.amount = recurringTransaction.amount
        transaction.category = recurringTransaction.category
        transaction.recurring = recurringTransaction
        transaction.note = recurringTransaction.note
        transaction.year = monthlyBudget.year
        transaction.month = monthlyBudget.month
        transaction.type = recurringTransaction.type
        transaction.date = recurringTransaction.nextAddingDate
        
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Could not save context")
            }
        }
    }
    
    static func update(from existingTransaction: Transaction, monthlyBudget: MonthlyBudget, context: NSManagedObjectContext) {
       
        let transaction = Transaction(context: context)
        transaction.amount = existingTransaction.amount
        transaction.date = existingTransaction.date
        transaction.month = existingTransaction.month
        transaction.year = existingTransaction.year
        transaction.type = existingTransaction.type
        transaction.category = existingTransaction.category
        transaction.monthlyBudget = monthlyBudget
        transaction.note = existingTransaction.note
        do {
            try context.save()
            print("Context saved")
        } catch {
            print("Could not save context")
        }
    }
    
    static func update(from info: TransactionInfo, monthlyBudget: MonthlyBudget, context: NSManagedObjectContext) {
        let month = getMonthFrom(date: info.date) ?? 0
        let year = getYearFrom(date: info.date) ?? 0
        //let type = TransactionType.getType(by: info.typeInfo, context: context)
        
        let transaction = Transaction(context: context)
        transaction.amount = info.amount
        transaction.date = info.date
        transaction.month = Int32(month)
        transaction.year = Int32(year)
        transaction.type = info.typeInfo
        transaction.category = info.typeInfo.category
        transaction.monthlyBudget = monthlyBudget
        transaction.note = info.note
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Could not save context")
            }
        }
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<Transaction> {
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = predicate
        return request
    }
}


