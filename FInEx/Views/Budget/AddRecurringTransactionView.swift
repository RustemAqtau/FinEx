//
//  AddRecurringTransactionView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-20.
//

import SwiftUI

struct AddRecurringTransactionView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.userSettingsVM) var userSettingsVM
    let geo: GeometryProxy
    
    let currentBudget: MonthlyBudget
    @State var recurringTransactions: [RecurringTransaction] //= []
    @Binding var addedRecurringTransaction: Bool
    
    var body: some View {
        let formatter = setDecimalFormatter(currencySymbol: userSettingsVM.settings.currencySymbol!, fractionDigitsNumber: self.userSettingsVM.settings.showDecimals ? 2 : 0)
        VStack {
            Text("Your recurring transactions are available to add")
                .font(Fonts.light15)
                .foregroundColor(CustomColors.TextDarkGray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            ZStack {
                ForEach(self.recurringTransactions, id: \.self) { transaction in
                    Group {
                        RoundedRectangle(cornerRadius:30)
                            .fill(Color.white)
                        RoundedRectangle(cornerRadius:30)
                            .stroke(Color.gray)
                        HStack {
                            HStack {
                                Group {
                                    Image(systemName: transaction.type!.presentingImageName)
                                        .foregroundColor(.white)
                                        .modifier(CircleModifierSimpleColor(color: Color(transaction.type!.presentingColorName), strokeLineWidth: 3.0))
                                        .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                        .font(Font.system(size: 24, weight: .regular, design: .default))
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(LocalizedStringKey(transaction.type!.presentingName))
                                            Text("•")
                                            Text(formatter.string(from: transaction.amount ?? 0)!)
                                        }
                                        .font(Fonts.light15)
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        HStack(spacing: 5) {
                                            Image(systemName: "arrow.triangle.2.circlepath")
                                            Text(LocalizedStringKey(transaction.periodicity!))
                                        }
                                        .font(Fonts.light12)
                                        .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                
                            }
                            .frame(width: geo.size.width * 0.70)
                            .scaledToFit()
                            
                            Button(action: {
                                self.budgetVM.addRecurringTransaction(info: transaction, monthlyBudget: currentBudget, context: viewContext)
                                transaction.updateNextAddingDate(context: viewContext)
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    self.addedRecurringTransaction.toggle()
                                }
                                
                            }) {
                                Image(systemName: Icons.Checkmark)
                                    .frame(width: geo.size.width * 0.20)
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .font(Fonts.light20)
                            }
                        }
                    }
                    .frame(width: geo.size.width * 0.90)
                }
            }
           // .background(CustomColors.White_Background)
        }
    }
}


