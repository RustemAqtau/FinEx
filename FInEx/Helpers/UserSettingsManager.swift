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
        getRecurringTransactionsByCategory(context: context)
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
            
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Salary.rawValue, imageName: CategoryIconNamesDefault.income_Salary.rawValue, colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Bonus.rawValue, imageName: CategoryIconNamesDefault.income_Bonus.rawValue, colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Pension.rawValue, imageName: CategoryIconNamesDefault.income_Pension.rawValue, colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Dividends.rawValue, imageName: CategoryIconNamesDefault.income_Dividends.rawValue, colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Interest.rawValue, imageName: CategoryIconNamesDefault.income_Interest.rawValue, colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.ChildBenefit.rawValue, imageName: CategoryIconNamesDefault.income_ChildBenefit.rawValue, colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: IncomeTypeNames.Gift.rawValue, imageName: CategoryIconNamesDefault.giftCard.rawValue, colorName: "NewBalanceColor", isHidden: false),
            
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.rawValue, name: ExpenseTypeNames.Restaurant.rawValue, imageName: CategoryIconNamesDefault.expense_Restaurant.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.rawValue, name: ExpenseTypeNames.Groceries.rawValue, imageName: CategoryIconNamesDefault.expense_Groceries.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.rawValue, name: ExpenseTypeNames.Delivery.rawValue, imageName: CategoryIconNamesDefault.expense_FoodDelivery.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.rawValue, name: ExpenseTypeNames.Coffee.rawValue, imageName: CategoryIconNamesDefault.expense_Coffee.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.rawValue, name: ExpenseTypeNames.Rent.rawValue, imageName: CategoryIconNamesDefault.expense_Rent.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.rawValue, name: ExpenseTypeNames.Loan.rawValue, imageName: CategoryIconNamesDefault.expense_Loan.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.rawValue, name: ExpenseTypeNames.Maintenance.rawValue, imageName: CategoryIconNamesDefault.expense_HousingMaintenance.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.rawValue, name: ExpenseTypeNames.Furniture.rawValue, imageName: CategoryIconNamesDefault.expense_Furniture.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: ExpenseTypeNames.Internet.rawValue, imageName: CategoryIconNamesDefault.expense_Wifi.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: ExpenseTypeNames.Electricity.rawValue, imageName: CategoryIconNamesDefault.expense_Electricity.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: ExpenseTypeNames.Heating.rawValue, imageName: CategoryIconNamesDefault.expense_Heating.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: ExpenseTypeNames.Water.rawValue, imageName: CategoryIconNamesDefault.expense_Water.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: ExpenseTypeNames.Mobile.rawValue, imageName: CategoryIconNamesDefault.expense_Phone.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: ExpenseTypeNames.Cinema.rawValue, imageName: CategoryIconNamesDefault.expense_CinemaTicket.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: ExpenseTypeNames.Concert.rawValue, imageName: CategoryIconNamesDefault.expense_Concert.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: ExpenseTypeNames.Hobby.rawValue, imageName: CategoryIconNamesDefault.expense_Hobby.rawValue, colorName: "ExpensesColor2", isHidden: false),
//            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: ExpenseTypeNames.Bowling.rawValue, imageName: "person.3", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: ExpenseTypeNames.Nightclub.rawValue, imageName: CategoryIconNamesDefault.expense_Nightclub.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: ExpenseTypeNames.Party.rawValue, imageName: CategoryIconNamesDefault.expense_Party.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: ExpenseTypeNames.Bar.rawValue, imageName: CategoryIconNamesDefault.expense_Bar.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            

            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Shopping.rawValue, name: ExpenseTypeNames.Clothing.rawValue, imageName: CategoryIconNamesDefault.expense_ClothingTShirt.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Shopping.rawValue, name: ExpenseTypeNames.Device.rawValue, imageName: CategoryIconNamesDefault.expense_ShoppingGadget2.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Shopping.rawValue, name: ExpenseTypeNames.Accessories.rawValue, imageName: CategoryIconNamesDefault.expense_Accessories.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Insurance.rawValue, name: ExpenseTypeNames.Car.rawValue, imageName: CategoryIconNamesDefault.expense_Car.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Insurance.rawValue, name: ExpenseTypeNames.InsuranceHealth.rawValue, imageName: CategoryIconNamesDefault.expense_HealthInsurance.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Insurance.rawValue, name: ExpenseTypeNames.InsuranceHouse.rawValue, imageName: CategoryIconNamesDefault.expense_HouseInsurance.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Subscriptions.rawValue, name: ExpenseTypeNames.TV.rawValue, imageName: CategoryIconNamesDefault.expense_TV.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Subscriptions.rawValue, name: ExpenseTypeNames.Music.rawValue, imageName: CategoryIconNamesDefault.expense_Music.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: ExpenseTypeNames.Loan.rawValue, imageName: "car.circle.fill", colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: ExpenseTypeNames.Gas.rawValue, imageName: CategoryIconNamesDefault.expense_Gas.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: ExpenseTypeNames.Parking.rawValue, imageName: CategoryIconNamesDefault.expense_Parking.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: ExpenseTypeNames.PublicTr.rawValue, imageName: CategoryIconNamesDefault.expense_PublicTr.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: ExpenseTypeNames.Repair.rawValue, imageName: CategoryIconNamesDefault.expense_CarRepair.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Health.rawValue, name: ExpenseTypeNames.Dentist.rawValue, imageName: CategoryIconNamesDefault.expense_Dentist.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Health.rawValue, name: ExpenseTypeNames.CheckUp.rawValue, imageName: CategoryIconNamesDefault.expense_CheckUp.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Travel.rawValue, name: ExpenseTypeNames.Flight.rawValue, imageName: CategoryIconNamesDefault.expense_Flight.rawValue, colorName: "ExpensesColor2", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Travel.rawValue, name: ExpenseTypeNames.Hotel.rawValue, imageName: CategoryIconNamesDefault.expense_Hotel.rawValue, colorName: "ExpensesColor2", isHidden: false),
            
            
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.LongTerm.rawValue, name: SavingTypeNames.Cash.rawValue, imageName: CategoryIconNamesDefault.savings_Cash2.rawValue, colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.LongTerm.rawValue, name: SavingTypeNames.Investments.rawValue, imageName: CategoryIconNamesDefault.savings_Investments.rawValue, colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.ShortTerm.rawValue, name: SavingTypeNames.Shopping.rawValue, imageName: CategoryIconNamesDefault.savings_CashPig.rawValue, colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.ShortTerm.rawValue, name: SavingTypeNames.Education.rawValue, imageName: CategoryIconNamesDefault.savings_Education.rawValue, colorName: "SavingsColor", isHidden: false)
            
        ]
    }

}


struct UserSettingsVMKey: EnvironmentKey {
    static var defaultValue: UserSettingsManager = UserSettingsManager()
}
