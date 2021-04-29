//
//  UserSettingsVM.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-10.
//

import Combine
import CoreData
import SwiftUI

class UserSettingsManager: ObservableObject {
    
    @Published var settings = UserSettings()
    @Published var allTransactionTypes: [TransactionType] = []
    @Published var transactionTypes: [TransactionType] = []
    @Published var allTransactionTypesByCategoty: [String : [String : [TransactionType]]] = [
        Categories.Income: [Categories.Income:[]],
        Categories.Expense : [
            ExpenseSubCategories.Bills.rawValue:[],
            ExpenseSubCategories.Housing.rawValue : [],
            ExpenseSubCategories.Entertainment.rawValue : [],
            ExpenseSubCategories.FoodAndDrinks.rawValue : [],
            ExpenseSubCategories.Shopping.rawValue : [],
            ExpenseSubCategories.Health.rawValue : [],
            ExpenseSubCategories.Insurance.rawValue : [],
            ExpenseSubCategories.Subscriptions.rawValue : [],
            ExpenseSubCategories.Transportation.rawValue : [],
            ExpenseSubCategories.Travel.rawValue : []],
        Categories.Saving : [SvaingSubCategories.LongTerm.rawValue : [],
                             SvaingSubCategories.ShortTerm.rawValue : []]]
    
    @Published var transactionTypesByCategoty: [String : [String : [TransactionType]]] = [
        Categories.Income: [Categories.Income:[]],
        Categories.Expense : [
            ExpenseSubCategories.Bills.rawValue:[],
            ExpenseSubCategories.Housing.rawValue : [],
            ExpenseSubCategories.Entertainment.rawValue : [],
            ExpenseSubCategories.FoodAndDrinks.rawValue : [],
            ExpenseSubCategories.Shopping.rawValue : [],
            ExpenseSubCategories.Health.rawValue : [],
            ExpenseSubCategories.Insurance.rawValue : [],
            ExpenseSubCategories.Subscriptions.rawValue : [],
            ExpenseSubCategories.Transportation.rawValue : [],
            ExpenseSubCategories.Travel.rawValue : []],
        Categories.Saving : [SvaingSubCategories.LongTerm.rawValue : [],
                             SvaingSubCategories.ShortTerm.rawValue : []]]
    
    let categories = [Categories.Income, Categories.Expense, Categories.Saving]
    
    var subCategories: [String: [String]] {
        var arr: [String: [String]] = [Categories.Income : [], Categories.Expense : [], Categories.Saving : []]
        
        arr[Categories.Income]!.append(Categories.Income)
        
        for elem in ExpenseSubCategories.allCases {
            arr[Categories.Expense]!.append(elem.rawValue)
        }
        for elem in SvaingSubCategories.allCases {
            arr[Categories.Saving]?.append(elem.rawValue)
        }
        return arr
    }
    
    @Published var recurringTransactions: [RecurringTransaction] = []
    @Published var recurringTransactionsByCategory: [String: [RecurringTransaction]] = [:]
    @Published var recurringTransactionsByCategoryForBudget: [String: [RecurringTransaction]] = [:]
     let cetegoriesArray = [Categories.Income, Categories.Expense, Categories.Saving]
    // MARK: - RecurringTransactions
    
    func addNewRecurringTransaction(info: RecurringTransactionInfo, context: NSManagedObjectContext) {
        RecurringTransaction.update(from: info, context: context)
        getRecurringTransactions(context: context)
    }
    func deleteRecurringTransaction(transaction: RecurringTransaction, context: NSManagedObjectContext) {
        transaction.delete(context: context)
        getRecurringTransactions(context: context)
    }
    
    func getRecurringTransactionsByCategory(monthlyBudget: MonthlyBudget, context: NSManagedObjectContext) {
        for category in cetegoriesArray {
            let transactions = fetchRecurringTransaction(for: category, monthlyBudget: monthlyBudget, context: context)
            recurringTransactionsByCategoryForBudget[category] = transactions
        }
    }
    
    func getRecurringTransactionsByCategory(context: NSManagedObjectContext) {
        for category in cetegoriesArray {
            let transactions = fetchRecurringTransaction(for: category, context: context)
            recurringTransactionsByCategory[category] = transactions
        }
    }
    
    private func fetchRecurringTransaction(for category: String, monthlyBudget: MonthlyBudget,  context: NSManagedObjectContext) -> [RecurringTransaction]? {
        var recurringTransactions: [RecurringTransaction] = []
        let predicate = NSPredicate(format: "category = %@ AND (nextAddingYear = %@ AND nextAddingMonth = %@)", argumentArray: [category, monthlyBudget.year, monthlyBudget.month])
        let request = RecurringTransaction.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            recurringTransactions = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return recurringTransactions
    }
    
    private func fetchRecurringTransaction(for category: String, context: NSManagedObjectContext) -> [RecurringTransaction]? {
        var recurringTransactions: [RecurringTransaction] = []
        let predicate = NSPredicate(format: "category = %@", argumentArray: [category])
        let request = RecurringTransaction.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            recurringTransactions = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return recurringTransactions
    }
    
    
    func getRecurringTransactions(context: NSManagedObjectContext) {
        recurringTransactions = fetchRecurringTransactions(context: context)
    }
    
    private func fetchRecurringTransactions(context: NSManagedObjectContext) -> [RecurringTransaction] {
        var recurringTransactions: [RecurringTransaction] = []
        let predicate = NSPredicate(format: "amount != nil")
        let request = RecurringTransaction.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            recurringTransactions = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return recurringTransactions
    }
    
    // MARK: - UserSettings
    
    func fetchUserSettins(context: NSManagedObjectContext) -> [UserSettings] {
        var userSettings:[UserSettings] = []
        let predicate = NSPredicate(format: "settingsId > 0")
        let request = UserSettings.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            userSettings = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return userSettings
    }
    
    func checkUserSettingsIsEmpty(context: NSManagedObjectContext) -> Bool {
        let userSettings = fetchUserSettins(context: context)
        return userSettings.isEmpty
    }
    
    func setUserSettings(context: NSManagedObjectContext) {
        let newUserSettingdInfo = UserSettingsInfo(settingsId: 1, isSignedWithAppleId: false, isSetPassCode: false)
        UserSettings.update(from: newUserSettingdInfo, context: context)
    }
    
    func getUserSettings(context: NSManagedObjectContext) {
        let fetchedSettings = fetchUserSettins(context: context)
        settings = fetchedSettings[0]
    }
    
    
    // MARK: - TransactionTypes
    
    func addNewTransactiontype(info: TransactionTypeInfo, context: NSManagedObjectContext) {
        TransactionType.update(from: info, context: context)
    }
    
    func loadDefaultTransactionTypes(context: NSManagedObjectContext) {
        for type in defaultTransactionTypes {
            TransactionType.update(from: type, context: context)
        }
        
    }
    
    func getAllTransactiontypes(context: NSManagedObjectContext) {
        let predicate = NSPredicate(format: "name != nil")
        allTransactionTypes = fetchTransactionTypes(context: context, predicate: predicate)
        for key in allTransactionTypesByCategoty.keys {
            for subKey in allTransactionTypesByCategoty[key]!.keys {
                allTransactionTypesByCategoty[key]?[subKey]?.removeAll()
                if key == Categories.Income {
                    for type in allTransactionTypes {
                        if type.category == key && type.subCategory == nil {
                            allTransactionTypesByCategoty[Categories.Income]?[Categories.Income]?.append(type)
                        }
                    }
                }
                for type in allTransactionTypes {
                    if type.category == key {
                        if type.subCategory != nil && type.subCategory == subKey {
                            allTransactionTypesByCategoty[key]?[subKey]?.append(type)
                        }
                    }
                }
            }
        }
    }
    
    func getTransactiontypes(context: NSManagedObjectContext) {
        let predicate = NSPredicate(format: "name != nil AND isHidden =  %@", argumentArray: [false])
        transactionTypes = fetchTransactionTypes(context: context, predicate: predicate)
        for key in transactionTypesByCategoty.keys {
            for subKey in transactionTypesByCategoty[key]!.keys {
                transactionTypesByCategoty[key]?[subKey]?.removeAll()
                if key == Categories.Income {
                    for type in transactionTypes {
                        if type.category == key && type.subCategory == nil {
                            transactionTypesByCategoty[Categories.Income]?[Categories.Income]?.append(type)
                        }
                    }
                }
                for type in transactionTypes {
                    if type.category == key {
                        if type.subCategory != nil && type.subCategory == subKey {
                            transactionTypesByCategoty[key]?[subKey]?.append(type)
                        }
                    }
                }
            }
        }
    }
    
    
    private func fetchTransactionTypes(context: NSManagedObjectContext, predicate: NSPredicate) -> [TransactionType] {
        var transactionTypes: [TransactionType] = []
        let request = TransactionType.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            transactionTypes = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return transactionTypes
    }
    
    func checkTransactionTypesIsEmpty(context: NSManagedObjectContext) -> Bool {
        let predicate = NSPredicate(format: "name != nil")
        let transactionTypes = fetchTransactionTypes(context: context, predicate: predicate)
        return transactionTypes.isEmpty
    }
    
    var defaultTransactionTypes: [TransactionTypeInfo] {
        return [
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Salary.localizedString(), imageName: "briefcase.fill", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Bonus.localizedString(), imageName: "bag.fill.badge.plus", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Pension.localizedString(), imageName: "p.square", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Dividends.localizedString(), imageName: "banknote.fill", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Interest.localizedString(), imageName: "building.columns.fill", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.ChildBenefit.localizedString(), imageName: "staroflife", colorName: "NewBalanceColor", isHidden: false),
            
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.localizedString(), name: ExpenseTypeNames.Rent.localizedString(), imageName: "house.circle.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.localizedString(), name: ExpenseTypeNames.Loan.localizedString(), imageName: "house.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.localizedString(), name: ExpenseTypeNames.Maintenance.localizedString(), imageName: "hammer.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.localizedString(), name: ExpenseTypeNames.Furniture.localizedString(), imageName: "bed.double.fill", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.localizedString(), name: ExpenseTypeNames.Internet.localizedString(), imageName: "wifi", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.localizedString(), name: ExpenseTypeNames.Electricity.localizedString(), imageName: "bolt.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.localizedString(), name: ExpenseTypeNames.Heating.localizedString(), imageName: "flame.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.localizedString(), name: ExpenseTypeNames.Water.localizedString(), imageName: "drop", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.localizedString(), name: ExpenseTypeNames.Mobile.localizedString(), imageName: "phone.connection", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.localizedString(), name: ExpenseTypeNames.Cinema.localizedString(), imageName: "film", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.localizedString(), name: ExpenseTypeNames.Concert.localizedString(), imageName: "guitars", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.localizedString(), name: ExpenseTypeNames.Hobby.localizedString(), imageName: "paintpalette", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.localizedString(), name: ExpenseTypeNames.Bowling.localizedString(), imageName: "person.3", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.localizedString(), name: ExpenseTypeNames.Nightclub.localizedString(), imageName: "timelapse", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.localizedString(), name: ExpenseTypeNames.Party.localizedString(), imageName: "person.2.square.stack", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.localizedString(), name: ExpenseTypeNames.Resraurant.localizedString(), imageName: "r.square", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.localizedString(), name: ExpenseTypeNames.Groceries.localizedString(), imageName: "cart", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.localizedString(), name: ExpenseTypeNames.Delivery.localizedString(), imageName: "shippingbox.fill", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Shopping.localizedString(), name: ExpenseTypeNames.Clothing.localizedString(), imageName: "creditcard.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Shopping.localizedString(), name: ExpenseTypeNames.Device.localizedString(), imageName: "gamecontroller", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Shopping.localizedString(), name: ExpenseTypeNames.Accessories.localizedString(), imageName: "eyeglasses", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Insurance.localizedString(), name: ExpenseTypeNames.Car.localizedString(), imageName: "car", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Subscriptions.localizedString(), name: ExpenseTypeNames.TV.localizedString(), imageName: "tv", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Subscriptions.localizedString(), name: ExpenseTypeNames.Music.localizedString(), imageName: "music.note.list", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.localizedString(), name: ExpenseTypeNames.Loan.localizedString(), imageName: "car.circle.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.localizedString(), name: ExpenseTypeNames.Gas.localizedString(), imageName: "gauge", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.localizedString(), name: ExpenseTypeNames.Parking.localizedString(), imageName: "p.circle.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.localizedString(), name: ExpenseTypeNames.PublicTr.localizedString(), imageName: "tram.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.localizedString(), name: ExpenseTypeNames.Repair.localizedString(), imageName: "wrench.fill", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Health.localizedString(), name: ExpenseTypeNames.Dentist.localizedString(), imageName: "mouth.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Health.localizedString(), name: ExpenseTypeNames.CheckUp.localizedString(), imageName: "stethoscope", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Travel.localizedString(), name: ExpenseTypeNames.Flight.localizedString(), imageName: "airplane", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Travel.localizedString(), name: ExpenseTypeNames.Hotel.localizedString(), imageName: "building", colorName: "ExpensesColor", isHidden: false),
            
            
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.LongTerm.localizedString(), name: SavingTypeNames.Cash.localizedString(), imageName: "dollarsign.circle.fill", colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.LongTerm.localizedString(), name: SavingTypeNames.Investments.localizedString(), imageName: "arrow.up.doc.fill", colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.ShortTerm.localizedString(), name: SavingTypeNames.Shopping.localizedString(), imageName: "cart.fill.badge.plus", colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.ShortTerm.localizedString(), name: SavingTypeNames.Education.localizedString(), imageName: "graduationcap.fill", colorName: "SavingsColor", isHidden: false)
            
        ]
    }

}


struct UserSettingsVMKey: EnvironmentKey {
    static var defaultValue: UserSettingsManager = UserSettingsManager()
}
