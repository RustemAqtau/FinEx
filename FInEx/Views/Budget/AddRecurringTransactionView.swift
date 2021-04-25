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
    @State var recurringTransactions: [RecurringTransaction] = []
    @Binding var addedRecurringTransaction: Bool
    
    var body: some View {
        let formatter = setDecimalFormatter()
        VStack {
            Text("You have upcoming expense")
                .font(Font.system(size: 14, weight: .regular, design: .default))
            ZStack {
                ForEach(self.recurringTransactions, id: \.self) { transaction in
                    Group {
                        RoundedRectangle(cornerRadius:30)
                            .fill(Color.white)
                        RoundedRectangle(cornerRadius:30)
                            .stroke(Color.white)
                        HStack {
                            HStack {
                                Group {
                                    Image(systemName: transaction.type!.presentingImageName)
                                        .foregroundColor(.white)
                                        .modifier(CircleModifierSimpleColor(color: Color(transaction.type!.presentingColorName), strokeLineWidth: 3.0))
                                        .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                        .font(Font.system(size: 24, weight: .regular, design: .default))
                                    VStack(alignment: .leading) {
                                        Text(LocalizedStringKey(transaction.type!.presentingName))
                                        Text(LocalizedStringKey(transaction.periodicity!))
                                            .font(Font.system(size: 15, weight: .light, design: .default))
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                Text("$" + formatter.string(from: transaction.amount ?? 0)!)
                            }
                            .frame(width: geo.size.width * 0.70)
                            .scaledToFit()
                            Button(action: {
                                self.budgetVM.addRecurringTransaction(info: transaction, monthlyBudget: currentBudget, context: viewContext)
                                transaction.updateNextAddingDate(context: viewContext)
                                self.addedRecurringTransaction.toggle()
                            }) {
                                Image(systemName: "checkmark.seal.fill")
                                    .frame(width: geo.size.width * 0.20)
                                    .foregroundColor(Color.green)
                                    .font(Font.system(size: 20, weight: .light, design: .default))
                            }
                        }
                    }
                    .frame(width: geo.size.width * 0.90)
                }
            }
        }
    }
}

struct AddRecurringTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            AddRecurringTransactionView(geo: geo, currentBudget: MonthlyBudget(), addedRecurringTransaction: .constant(false))
        }
        
    }
}
