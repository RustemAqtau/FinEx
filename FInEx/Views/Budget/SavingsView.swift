//
//  SavingsView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

struct SavingsView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    let geo: GeometryProxy
    @Environment(\.userSettingsVM) var userSettingsVM
    
    @Binding var currentMonthBudget: MonthlyBudget
    
    @Binding var savingsTypesBySubCategory: [String : [TransactionType]]
    @Binding var savingsTotalAmountByType: [TransactionType : Decimal]
    @Binding var currentMonthSavingsByType: [TransactionType : [Transaction]]
    @Binding var recurringTransactionsSaving: [RecurringTransaction]
    
    @State var subCategories: [String] = []
    @State var typesInSubCategory: [String : [TransactionType]] = [:]
    
    @Binding var addedRecurringTransaction: Bool
    @State var editingType: TransactionType = TransactionType()
    @State private var showWithdrawSheet: Bool = false
    
    var body: some View {
        let formatter = setDecimalFormatter(currencySymbol: userSettingsVM.settings.currencySymbol!, fractionDigitsNumber: self.userSettingsVM.settings.showDecimals ? 2 : 0)
        ScrollView {
            VStack(spacing: 15) {
                if !self.recurringTransactionsSaving.isEmpty {
                    AddRecurringTransactionView(geo: geo, currentBudget: self.currentMonthBudget, recurringTransactions: self.recurringTransactionsSaving, addedRecurringTransaction: self.$addedRecurringTransaction)
                        .environmentObject(budgetVM)
                }
                if !self.savingsTypesBySubCategory.isEmpty {
                    ForEach(self.savingsTypesBySubCategory.keys.sorted(), id: \.self) { subCategory in
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .frame(width: geo.size.width, alignment: .leading)
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Group {
                                        Text(LocalizedStringKey(subCategory))
                                    }
                                    Spacer()
                                }
                                .foregroundColor(CustomColors.TextDarkGray)
                                .frame(width: geo.size.width / 1.2 )
                                .font(Font.system(size: 18, weight: .light, design: .rounded))
                                .scaledToFit()
                                .padding()
                                Divider()
                                
                                ForEach(savingsTypesBySubCategory[subCategory]!, id: \.self) { type in
                                    HStack {
                                        Group {
                                            Image(systemName: type.presentingImageName)
                                                .foregroundColor(.white)
                                                .modifier(CircleModifierSimpleColor(color: Color(type.presentingColorName), strokeLineWidth: 3.0))
                                                .frame(width: geo.size.width * 0.10, height: geo.size.width * 0.10, alignment: .center)
                                                .font(Font.system(size: 20, weight: .regular, design: .default))
                                                .animation(.linear(duration: 0.5))
                                            
                                            VStack(alignment: .leading) {
                                                Text(LocalizedStringKey(type.presentingName))
                                                    .shadow(radius: -10 )
                                                
                                            }
                                            .animation(.linear(duration: 0.5))
                                        }
                                        Spacer()
                                        Text(formatter.string(from: NSDecimalNumber(decimal: savingsTotalAmountByType[type] ?? 0) )!)
                                            .animation(.linear(duration: 0.5))
                                        
                                    }
                                    .frame(width: geo.size.width / 1.1  )
                                    .scaledToFit()
                                    .onTapGesture {
                                        self.editingType = type
                                        self.showWithdrawSheet = true
                                    }
                                    Divider()
                                    if !currentMonthSavingsByType.isEmpty,
                                       let transaction = currentMonthSavingsByType[type] {
                                        ForEach(currentMonthSavingsByType[type]!, id: \.self) { transaction in
                                            HStack {
                                                Group {
                                                    Text(setDate(date: transaction.date!))
                                                    
                                                }
                                                Spacer()
                                                Text(formatter.string(from: transaction.amount ?? 0)!)
                                                    .animation(.linear(duration: 0.5))
                                            }
                                            .frame(width: geo.size.width / 1.1 )
                                            .scaledToFit()
                                            .font(Font.system(size: 15, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.TextDarkGray)
                                            Divider()
                                        }
                                    }
                                    
                                }
                            }
                            .padding(.horizontal)
                            .transition(.asymmetric(insertion: AnyTransition.opacity.combined(with: .slide), removal: .scale))
                        }
                        .background(Color.white)
                        .padding(.horizontal)
                        
                    }
                    .frame(width: geo.size.width)
                } else {
                    NoDataPlaceholderView()
                    .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5, alignment: .center)
                }
                
            }
            VStack {
                
            }
            .frame(width: geo.size.width, height: geo.size.height / 4, alignment: .center)
            
        }
        .onAppear {
            print(self.currentMonthSavingsByType)
        }
        .sheet(isPresented: self.$showWithdrawSheet, content: {
            withAnimation(.easeInOut(duration: 2)) {
                WithdrawSavingView(currentMonthBudget: self.$currentMonthBudget, savingsType: self.$editingType)
                    .environmentObject(self.budgetVM)
            }
        })
    }
    
}

//struct SavingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeometryReader { geo in
//            SavingsView(geo: geo, savingsByType: .constant([:]), addedRecurringTransaction: .constant(false))
//        }
//        
//    }
//}
