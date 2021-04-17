//
//  ExpensesView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

struct ExpensesView: View {
    @EnvironmentObject var budgetVM: BudgetVM
    @Environment(\.managedObjectContext) private var viewContext
    let geo: GeometryProxy
    @Binding var expensesBySubCategory: [String : [Transaction]]
    @State var subCategories: [String] = []
    @State var expensesTotalAmountBySubCategory: [String : Decimal] = [:]
    var body: some View {
        let formatter = setDecimalFormatter()
        //  if let currentBudget = budgetVM.budgetList.last {
        ScrollView {
            VStack {
                ForEach(self.subCategories, id: \.self) { subCategory in
                    VStack(alignment: .leading) {
                        HStack {
                            Group {
                                Text(subCategory)
                                
                            }
                            Spacer()
                            
                            Text("$" + formatter.string(from: NSDecimalNumber(decimal: expensesTotalAmountBySubCategory[subCategory] ?? 0))!)
                        }
                        .foregroundColor(Color("TextDarkGray"))
                        .frame(width: geo.size.width / 1.2 )
                        .font(Font.system(size: 18, weight: .light, design: .default))
                        .scaledToFit()
                        .padding()
                        
                        Divider()
                        
                        ForEach(expensesBySubCategory[subCategory]!, id: \.date) { expense in
                            HStack {
                                Group {
                                    Image(systemName: expense.type!.presentingImageName)
                                        .foregroundColor(.white)
                                        .modifier(CircleModifier(color: Color(expense.type!.presentingColorName), strokeLineWidth: 3.0))
                                        .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                        .font(Font.system(size: 24, weight: .regular, design: .default))
                                    VStack(alignment: .leading) {
                                        Text(expense.type!.presentingName)
                                            .shadow(radius: -10 )
                                        Text(setDate(date: expense.date!))
                                            .font(Font.system(size: 15, weight: .light, design: .default))
                                            .foregroundColor(.gray)
                                        
                                    }
                                }
                                
                                Spacer()
                                Text("$" + formatter.string(from: expense.amount ?? 0)!)
                            }
                            .frame(width: geo.size.width / 1.15 )
                            .scaledToFit()
                            
                            Divider()
                        }
                        .onDelete(perform: {indexSet in withAnimation {  deleteTransaction(subCategory: subCategory, at: indexSet)} })
                    }
                    .padding()
                }
                .background(Color.white)
                //.onDelete(perform: { indexSet in print(indexSet) })
            }
            .frame(width: geo.size.width)
            
            VStack {
                
            }
            .frame(width: geo.size.width, height: geo.size.height / 4, alignment: .center)
        }
        .onAppear {
            for key in expensesBySubCategory.keys.sorted() {
                self.subCategories.append(key)
            }
            for subCategory in self.subCategories {
                var totalAmount: Decimal = 0
                for transaction in expensesBySubCategory[subCategory]! {
                    totalAmount  += transaction.amount! as Decimal
                }
                expensesTotalAmountBySubCategory[subCategory] = totalAmount
            }
            
            //}
        }
    }
    func deleteTransaction(subCategory: String, at indexSet: IndexSet) {
        for index in indexSet {
            expensesBySubCategory[subCategory]![index].delete(context: viewContext)
        }
    }
    
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ExpensesView(geo: geo, expensesBySubCategory: .constant([:]) )
        }
        
    }
}

