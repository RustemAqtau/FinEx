//
//  RecurringTransactionsView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-18.
//

import SwiftUI

struct RecurringTransactionsView: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext)  var viewContext
    @Binding var  hideTabBar: Bool
    @State var recurringTransactionsByCategory: [String : [RecurringTransaction]] = [:]
    @State var isAddingTransaction: Bool = false
    @State var addingCategory: String = ""
    private let cetegoriesArray = [Categories.Income, Categories.Expense, Categories.Saving]
    
    @State var editTransaction: Bool = false
    @State var editingTransaction: RecurringTransaction = RecurringTransaction()
    
    var body: some View {
        let formatter = setDecimalFormatter(currencySymbol: userSettingsVM.settings.currencySymbol!)
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(userSettingsVM.cetegoriesArray, id: \.self) { category in
                            HStack {
                                Text(NSLocalizedString("Recurring ", comment: "") + NSLocalizedString(category, comment: ""))
                                    .font(Fonts.light20)
                                Spacer()
                                Button(action: {
                                    self.isAddingTransaction = true
                                    self.addingCategory = category
                                }) {
                                    Image(systemName: "plus")
                                }
                                .sheet(isPresented: $isAddingTransaction, content: {
                                    withAnimation(.easeInOut(duration: 2)) {
                                        SetRecurringTransactionView(category: self.$addingCategory)
                                            .environmentObject(userSettingsVM)
                                    }
                                })

                            }
                            .foregroundColor(CustomColors.TextDarkGray)
                            .font(Font.system(size: 18, weight: .light, design: .default))
                            .frame(width: geo.size.width / 1.15 )
                            .scaledToFit()
                            Divider()
                            ForEach(self.recurringTransactionsByCategory[category] ?? [], id: \.self) { transaction in
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
                                                    Text(transaction.periodicity!)
                                                        .font(Font.system(size: 15, weight: .light, design: .default))
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            
                                        }
                                        
                                        Spacer()
                                        Text(formatter.string(from: transaction.amount ?? 0)!)
                                    }
                                    .frame(width: geo.size.width / 1.15)
                                    .scaledToFit()
                                    .onTapGesture {
                                        self.editingTransaction = transaction
                                        self.editTransaction = true
                                    }
                                }
                            }
                        }
                    
                    
                    }
                    VStack {
                    }
                    .frame(height: 100)
                    
                }
                .onAppear {
                    self.hideTabBar = true
                    userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
                    self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
                    
                }
                .onChange(of: self.isAddingTransaction, perform: { value in
                    userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
                    self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
                })
                .onChange(of: self.userSettingsVM.recurringTransactions.count, perform: { value in
                    userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
                    self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
                })
                .onChange(of: self.editTransaction, perform: { value in
                    userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
                    self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
                })
                .navigationBarTitle (Text(""), displayMode: .inline)
                .sheet(isPresented: self.$editTransaction, content: {
                    withAnimation(.easeInOut(duration: 2)) {
                        EditRecurringTransactionView(transaction: self.$editingTransaction)
                            .environment(\.userSettingsVM, userSettingsVM)
                    }
                })
            }
        }
    }
}
