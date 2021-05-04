//
//  RecurringTransactionsView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-18.
//

import SwiftUI

struct RecurringTransactionsView: View {
    @EnvironmentObject var userSettingsVM: UserSettingsManager
    @Environment(\.managedObjectContext)  var viewContext
    @Binding var  hideTabBar: Bool
    @State var recurringTransactionsByCategory: [String : [RecurringTransaction]] = [:]
    @State var isAddingTransaction: Bool = false
    @State var addingCategory: String = ""
    private let cetegoriesArray = [Categories.Income, Categories.Expense, Categories.Saving]
    
    @State var editTransaction: Bool = false
    @State var editingTransaction: RecurringTransaction = RecurringTransaction()
    @State var activeSheet: ActiveSheet?
    
    var body: some View {
        let formatter = setDecimalFormatter(currencySymbol: userSettingsVM.settings.currencySymbol!, fractionDigitsNumber: self.userSettingsVM.settings.showDecimals ? 2 : 0)
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    
                    VStack(spacing: 20) {
                        ForEach(userSettingsVM.cetegoriesArray, id: \.self) { category in
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .shadow(radius: 5)
                                    .frame(width: geo.size.width, alignment: .leading)
                                VStack {
                                    HStack {
                                        Text(NSLocalizedString("Recurring ", comment: "") + NSLocalizedString(category, comment: ""))
                                            .font(Fonts.light20)
                                        
                                        Spacer()
                                        Button(action: {
                                            activeSheet = .add
                                            self.isAddingTransaction = true
                                            self.addingCategory = category
                                        }) {
                                            Image(systemName: "plus")
                                        }
                                    }
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .font(Font.system(size: 18, weight: .light, design: .default))
                                    .frame(width: geo.size.width / 1.15 )
                                    .scaledToFit()
                                    Divider()
                                    ForEach(userSettingsVM.recurringTransactionsByCategory[category] ?? [], id: \.self) { transaction in
                                        VStack {
                                            HStack {
                                                Group {
                                                    if let type = transaction.type {
                                                        Image(systemName: type.presentingImageName)
                                                            .foregroundColor(.white)
                                                            .modifier(CircleModifierSimpleColor(color: Color(type.presentingColorName), strokeLineWidth: 3.0))
                                                            .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                                            .font(Font.system(size: 24, weight: .regular, design: .default))
                                                        VStack(alignment: .leading) {
                                                            Text(type.presentingName)
                                                                .shadow(radius: -10 )
                                                                .foregroundColor(CustomColors.TextDarkGray)
                                                            Text(transaction.periodicity!)
                                                                .font(Font.system(size: 15, weight: .light, design: .default))
                                                                .foregroundColor(.gray)
                                                        }
                                                    }
                                                }
                                                Spacer()
                                                Text(formatter.string(from: transaction.amount ?? 0)!)
                                                    .foregroundColor(CustomColors.TextDarkGray)
                                            }
                                            .frame(width: geo.size.width / 1.15)
                                            .scaledToFit()
                                            .onTapGesture {
                                                activeSheet = .edit
                                                self.editingTransaction = transaction
                                                self.editTransaction = true
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical)
                            }
                        }
                    }
                    .navigationBarTitle (Text(""), displayMode: .inline)
                    VStack {
                    }
                    .frame(height: 100)
                    
                }
                .background(CustomColors.White_Background)
                .ignoresSafeArea(.all, edges: .bottom)
                .onAppear {
                    self.hideTabBar = true
                    userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
                    self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
                    
                }
                
                

            }

            .sheet(item: $activeSheet) { item in
                        switch item {
                        case .add:
                            withAnimation(.easeInOut(duration: 2)) {
                                SetRecurringTransactionView(category: self.$addingCategory)
                                    .environment(\.userSettingsVM, self.userSettingsVM)
                            }
                        case .edit:
                            withAnimation(.easeInOut(duration: 2)) {
                                EditRecurringTransactionView(transaction: self.$editingTransaction)
                                    //.environment(\.userSettingsVM, userSettingsVM)
                            }
                        }
                    }
        }
        .onChange(of: self.isAddingTransaction, perform: { value in
            self.hideTabBar = true
            userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
            self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
        })
        .onChange(of: self.userSettingsVM.recurringTransactions.count, perform: { value in
            self.hideTabBar = true
            userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
            self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
        })
        .onChange(of: self.editTransaction, perform: { value in
            self.hideTabBar = true
            userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
            self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
        })
    }
}

