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
    
    @State var recurringTransactionsByCategory: [String : [RecurringTransaction]] = [:]
    @State var isAddingTransaction: Bool = false
    @State var addingCategory: String = ""
    private let cetegoriesArray = [Categories.Income, Categories.Expense, Categories.Saving]
    var body: some View {
        let formatter = setDecimalFormatter()
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(userSettingsVM.cetegoriesArray, id: \.self) { category in
                            HStack {
                                Text("Recurring " + category)
                                    .font(Font.system(size: 25, weight: .regular, design: .default))
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
                                            Image(systemName: transaction.type!.presentingImageName)
                                                .foregroundColor(.white)
                                                .modifier(CircleModifierSimpleColor(color: Color(transaction.type!.presentingColorName), strokeLineWidth: 3.0))
                                                .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                                .font(Font.system(size: 24, weight: .regular, design: .default))
                                            VStack(alignment: .leading) {
                                                Text(transaction.type!.presentingName)
                                                    .shadow(radius: -10 )
                                                Text(transaction.periodicity!)
                                                    .font(Font.system(size: 15, weight: .light, design: .default))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        
                                        Spacer()
                                        Text("$" + formatter.string(from: transaction.amount ?? 0)!)
                                    }
                                    .frame(width: geo.size.width / 1.15)
                                    .scaledToFit()
                                }
                            }
                        }
                    
                    
                    }
                    VStack {
                    }
                    .frame(height: 100)
                    
                }
                .onAppear {
                    userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
                    self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
                    
                }
                .onChange(of: userSettingsVM.recurringTransactions.count, perform: { value in
                    userSettingsVM.getRecurringTransactionsByCategory(context: viewContext)
                    self.recurringTransactionsByCategory = userSettingsVM.recurringTransactionsByCategory
                })
                .navigationBarTitle (Text(""), displayMode: .inline)
            }
        }
    }
}

struct RecurringTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        RecurringTransactionsView()
    }
}
