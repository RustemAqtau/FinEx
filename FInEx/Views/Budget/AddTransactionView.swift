//
//  AddExpense.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.userSettingsVM) var userSettingsVM
    @Binding var currentMonthBudget: MonthlyBudget
    @State var category: String
    
    @State var amount: NSDecimalNumber = 0
    @State private var amountString: String = ""
    @State private var amountIsEditing: Bool = false
    @State var selectedtypeImageName: String = "questionmark"
    @State var selectedTypeCircleColor: String = "TopGradient"
    @State var selectedTypeName: String = NSLocalizedString("Category", comment: "")
    @State var selectedType: TransactionType = TransactionType()
    @State var showCategorySelector: Bool = false
    @State var selectedDate: Date = Date()
    @State var note: String = ""
    @State var noteLenghtLimitOut: Bool = false
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let startComponents = DateComponents(year: year, month: 1, day: 1)
        let endComponents = DateComponents(year: year, month: month, day: day)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    @State var showCalendar: Bool = false
    @State var accentColor: Color = CustomColors.ExpensesColor2
    @State var validationFailed: Bool = false
    @State var warningMessage: String = ""
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 30) {
                    Text(warningMessage)
                        .font(Fonts.light12)
                        .foregroundColor(.gray)
                        .opacity(self.validationFailed ? 1 : 0)
                    ZStack {
                        RoundedRectangle(cornerRadius: 35.0)
                            .fill(Color.white)
                        RoundedRectangle(cornerRadius: 35.0)
                            .stroke(self.accentColor)
                        TextField("$", text: self.$amountString, onEditingChanged: { isEditing in
                            if isEditing {
                                self.amountIsEditing = true
                                
                            } else {
                                self.amountIsEditing = false
                            }
                        })
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .cornerRadius(25)
                        .accentColor(CustomColors.TextDarkGray)
                        .introspectTextField { textField in
                            textField.becomeFirstResponder()
                            textField.textAlignment = NSTextAlignment.center
                        }
                        .font(Font.system(size: 30, weight: .light, design: .default))
                        .keyboardType(.decimalPad)
                     }
                    .frame(width: geo.size.width * 0.60, height: 60, alignment: .center)
                    
                    Divider()
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 5)
                                    .stroke(self.accentColor)
                                    .frame(width: 43, height: 43, alignment: .center)
                                    .opacity(self.selectedTypeName == Placeholders.NewCategorySelector ? 1 : 0)
                                Image(systemName: self.selectedtypeImageName)
                                    .foregroundColor(.white)
                                    .modifier(CircleModifierSimpleColor(color: Color(self.selectedTypeCircleColor), strokeLineWidth: 3.0))
                                    .font(Font.system(size: 22, weight: .regular, design: .default))
                                    .frame(width: 43, height: 43, alignment: .center)
                            }
                            Text(self.selectedTypeName)
                                .font(Font.system(size: 16, weight: .light, design: .default))
                                .foregroundColor(CustomColors.TextDarkGray)
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        .onTapGesture {
                            self.showCategorySelector = true
                        }
                        
                        HStack(spacing: 15) {
                            Image(systemName: "calendar")
                                .foregroundColor(self.accentColor)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                                .onTapGesture {
                                    self.showCalendar = true
                                }
                            DatePicker("Label", selection: self.$selectedDate,
                                            in: dateRange,
                                            displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.clear)
                                .foregroundColor(CustomColors.TextDarkGray)
                                .accentColor(CustomColors.TextDarkGray)
                                .shadow(radius: 10.0 )
                                
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        HStack(spacing: 25) {
                            Image(systemName: "pencil")
                                .foregroundColor(self.accentColor)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                            TextField(LocalizedStringKey("Note"), text: self.$note,
                                      onEditingChanged: {isEditing in if isEditing {
                                        if !self.note.isEmpty {
                                            //self.note = ""
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
                            .foregroundColor(self.noteLenghtLimitOut ? .red : CustomColors.TextDarkGray)
                                .font(Font.system(size: 16, weight: .light, design: .default))
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        Button(action: {
                            if validationSucceed() {
                                saveTransaction()
                            }
                        }) {
                            SaveButtonView(geo: geo, withTrash: false)
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .ignoresSafeArea(.all, edges: .bottom)
                
            }
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                    .font(Font.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(CustomColors.TextDarkGray)
            })
            .navigationBarTitle (Text(""), displayMode: .inline)
        }
        .onAppear {
            self.showCategorySelector = false
            switch category {
            case Categories.Income:
                self.accentColor = CustomColors.IncomeGradient1
            case Categories.Expense:
                self.accentColor = CustomColors.ExpensesColor2
            case Categories.Saving:
                self.accentColor = CustomColors.SavingsGradient1
            default: self.accentColor = CustomColors.ExpensesColor2
            }
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
        .onChange(of: self.selectedtypeImageName, perform: { value in
            validationFailed = false
        })
        .onChange(of: self.amountString, perform: { value in
            validationFailed = false
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
        budgetVM.addNewTransaction(
            info: newTransactionInfo,
            monthlyBudget: self.currentMonthBudget,
            context: viewContext
        )
        budgetVM.getTransactions(context: viewContext)
        presentationMode.wrappedValue.dismiss()
    }
    func validationSucceed() -> Bool {
        guard !self.amountString.isEmpty,
              !Double(truncating: NSDecimalNumber(string: self.amountString)).isNaN
        else {
            self.validationFailed = true
            self.warningMessage = WarningMessages.ValidationAmountFail
            return false
            
        }
        
        guard self.selectedTypeName != Placeholders.NewCategorySelector else {
            self.validationFailed = true
            self.warningMessage = WarningMessages.ValidationCategoryNotSelectedFail
            return false
        }
        return true
    }
}

//struct AddExpense_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTransactionView(currentMonthBudget: MonthlyBudget(), category: Categories.Expense)
//    }
//}
