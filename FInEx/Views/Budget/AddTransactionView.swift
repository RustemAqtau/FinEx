//
//  AddExpense.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var budgetVM: BudgetVM
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.userSettingsVM) var userSettingsVM
    @State var currentMonthBudget: MonthlyBudget
    @State var category: String
    
    @State var amount: NSDecimalNumber = 0
    @State private var amountString: String = ""
    @State private var amountIsEditing: Bool = false
    @State var selectedtypeImageName: String = "questionmark"
    @State var selectedTypeCircleColor: String = "TopGradient"
    @State var selectedTypeName: String = "Category"
    @State var selectedType: TransactionType = TransactionType()
    @State var showCategorySelector: Bool = false
    @State var selectedDate: Date = Date()
    @State var note: String = "Note"
    @State var noteLenghtLimitOut: Bool = false
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let startComponents = DateComponents(year: year, month: month, day: 1)
        let endComponents = DateComponents(year: year, month: month, day: day)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    @State var showCalendar: Bool = false
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 30) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 35.0)
                            .fill(Color.white)
                            .opacity(self.amountIsEditing ? 1 : 0)
                        RoundedRectangle(cornerRadius: 35.0)
                            .stroke(Color.gray)
                            .shadow(radius: 5.0 )
                            .opacity(self.amountIsEditing ? 1 : 0)
                        TextField("$", text: self.$amountString, onEditingChanged: { isEditing in
                            
                            if isEditing {
                                self.amountIsEditing = true
                                self.amountString = ""
                            } else {
                                self.amountIsEditing = false
                                
                            }
                        })
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .cornerRadius(25)
                        .accentColor(Color("TextDarkGray"))
                        .introspectTextField { textField in
                            textField.becomeFirstResponder()
                            textField.textAlignment = NSTextAlignment.center
                        }
                        .font(Font.system(size: 30, weight: .light, design: .default))
                        .keyboardType(.decimalPad)
                        .padding()
                        
                    }
                    .frame(width: geo.size.width / 2, height: 60, alignment: .center)
                    Text(String(describing: self.amountString))
                    
                    Divider()
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            Image(systemName: self.selectedtypeImageName)
                                .foregroundColor(.white)
                                .modifier(CircleModifierSimpleColor(color: Color(self.selectedTypeCircleColor), strokeLineWidth: 3.0))
                                .font(Font.system(size: 24, weight: .regular, design: .default))
                                .frame(width: 50, height: 50, alignment: .center)
                                .onTapGesture {
                                    self.showCategorySelector = true
                                }
                            Text(self.selectedTypeName)
                                .font(Font.system(size: 20, weight: .light, design: .default))
                                .foregroundColor(Color("TextDarkGray"))
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        
                        HStack(spacing: 15) {
                            Image(systemName: "pencil")
                                .foregroundColor(Color("TextDarkGray"))
                                .font(Font.system(size: 45, weight: .regular, design: .default))
                            TextField(self.note, text: self.$note,
                                      onEditingChanged: {isEditing in if isEditing {
                                        if !self.note.isEmpty {
                                            self.note = ""
                                        }
                                        self.noteLenghtLimitOut = false
                                        
                                      } else {
                                        if self.note.count > 10 {
                                          self.noteLenghtLimitOut = true
                                            // TODO: Warning label
                                        }
                                      }
                            
                                      } , onCommit:  {
                                        
                                      })
                            .foregroundColor(self.noteLenghtLimitOut ? .red : Color("TextDarkGray"))
                                .font(Font.system(size: 20, weight: .light, design: .default))
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        
                        HStack(spacing: 15) {
                            Image(systemName: "calendar")
                                .foregroundColor(Color("TextDarkGray"))
                                .font(Font.system(size: 45, weight: .regular, design: .default))
                                .onTapGesture {
                                    self.showCalendar = true
                                }
                            DatePicker("Lable", selection: self.$selectedDate,
                                            in: dateRange,
                                            displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.clear)
                                .foregroundColor(Color("TextDarkGray"))
                                .accentColor(Color("TextDarkGray"))
                                .shadow(radius: 10.0 )
                                
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        .padding()
                       
                        Divider()
                        Button(action: {
                            saveTransaction()
                            
                        }) {
                            SaveButtonView(geo: geo)
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .ignoresSafeArea(.all, edges: .bottom)

            }
        }
        .onAppear {
            self.showCategorySelector = false
        }
        .onTapGesture {
            hideKeyboard()
            self.amountIsEditing = false
        }
        .sheet(isPresented: self.$showCategorySelector, content: {
            CategotySelector(categoty: self.category,
                             selectedType: self.$selectedType,
                             selectedtypeImageName: self.$selectedtypeImageName,
                             selectedTypeCircleColor: self.$selectedTypeCircleColor,
                             selectedTypeName: self.$selectedTypeName)
        })
        
    }
    func saveTransaction() {
        let locale = Locale.current
        self.amount = NSDecimalNumber(string: self.amountString, locale: locale)
        print(self.amount)
        let newTransactionInfo = TransactionInfo(
            amount: self.amount,
            date: self.selectedDate,
            typeInfo: self.selectedType,
            note: self.note
        )
        print(newTransactionInfo)
        budgetVM.addNewTransaction(
            info: newTransactionInfo,
            monthlyBudget: self.currentMonthBudget,
            context: viewContext
        )
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(currentMonthBudget: MonthlyBudget(), category: Categories.Expense)
    }
}
