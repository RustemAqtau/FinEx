//
//  EditTransactionview.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-22.
//

import SwiftUI

struct EditTransactionView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.userSettingsVM) var userSettingsVM
    @Binding var transaction: Transaction
    
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
    @State var dateRange: ClosedRange<Date> = (Date()...Date())
    
    @State var showCalendar: Bool = false
    @State var accentColor: Color = CustomColors.ExpensesColor2
    @State var validationFailed: Bool = false
    @State var warningMessage: String = ""
    @State var amountPlaceholder: String = ""
    @Binding var currencySymbol: String
    //@Binding var showDecimals: Bool
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 30) {
                    Text(LocalizedStringKey(warningMessage))
                        .font(Fonts.light12)
                        .foregroundColor(.gray)
                        .opacity(self.validationFailed ? 1 : 0)
                    ZStack {
                        RoundedRectangle(cornerRadius: 35.0)
                            .fill(Color.white)
                        RoundedRectangle(cornerRadius: 35.0)
                            .stroke(self.accentColor)
                        TextField(self.amountPlaceholder, text: self.$amountString, onEditingChanged: { isEditing in
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
                                    .opacity(self.selectedTypeName == Placeholders.NewCategorySelector.localizedString() ? 1 : 0)
                                Image(self.selectedtypeImageName)
                                    .foregroundColor(.white)
                                    .modifier(CircleModifierSimpleColor(color: Color(self.selectedTypeCircleColor), strokeLineWidth: 3.0))
                                    .font(Font.system(size: 22, weight: .regular, design: .default))
                                    .frame(width: 43, height: 43, alignment: .center)
                            }
                            Text(LocalizedStringKey(self.selectedTypeName))
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
                            TextField(LocalizedStringKey(Placeholders.Note.localizedString()), text: self.$note,
                                      onEditingChanged: {isEditing in if isEditing {
                                        if !self.note.isEmpty {
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
                        HStack(spacing: 20) {
                            Button(action: {
                                self.budgetVM.deleteTransaction(transaction: transaction, context: viewContext)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: Icons.Trash)
                                    .shadow(radius: 5)
                            }
                            .modifier(CircleModifierSimpleColor(color: .gray, strokeLineWidth: 2))
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                            .frame(height: 55)
                            Button(action: {
                                if validationSucceed() {
                                    saveTransaction()
                                }
                            }) {
                                SaveButtonView(geo: geo, withTrash: true, withdraw: false)
                            }
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .center)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .ignoresSafeArea(.all, edges: .bottom)
                
            }
            .background(CustomColors.White_Background)
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
            switch transaction.category! {
            case Categories.Income:
                self.accentColor = CustomColors.IncomeGradient1
            case Categories.Expense:
                self.accentColor = CustomColors.ExpensesColor2
            case Categories.Saving:
                self.accentColor = CustomColors.SavingsGradient1
            default: self.accentColor = CustomColors.ExpensesColor2
            }
            
            self.selectedDate = transaction.date!
            
            self.dateRange = getDateRange(for: transaction.date!)
            let formatter = setDecimalFormatter(currencySymbol: self.currencySymbol, fractionDigitsNumber: self.userSettingsVM.settings.showDecimals ? 2 : 0)
            var amount = formatter.string(from: NSDecimalNumber(decimal: transaction.amount! as Decimal))!
            
            amount.removeAll(where: {$0 == Character(self.currencySymbol) })
            amount.removeAll(where: {$0 == ","})
            amount.removeAll(where: {$0 == " "})
            self.amountString = amount 
            self.selectedType = transaction.type!
            self.selectedTypeName = transaction.type!.presentingName
            self.selectedtypeImageName = transaction.type!.presentingImageName
            self.selectedTypeCircleColor = transaction.type!.presentingColorName
            self.note = transaction.note!
            self.amountPlaceholder = currencySymbol //userSettingsVM.settings.currencySymbol!
        }
        .onTapGesture {
            hideKeyboard()
            self.amountIsEditing = false
        }
        .sheet(isPresented: self.$showCategorySelector, content: {
            CategotySelector(category: self.transaction.category!,
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
    
    private func saveTransaction() {
        let locale = Locale.current
        self.amount = NSDecimalNumber(string: self.amountString, locale: locale)
        print(self.amount)
        let newTransactionInfo = TransactionInfo(
            amount: self.amount,
            date: self.selectedDate,
            typeInfo: self.selectedType,
            note: self.note
        )
        budgetVM.editTransaction(transaction: self.transaction, info: newTransactionInfo, context: viewContext)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func validationSucceed() -> Bool {
        guard !self.amountString.isEmpty,
              !Double(truncating: NSDecimalNumber(string: self.amountString)).isNaN
        else {
            self.validationFailed = true
            self.warningMessage = WarningMessages.ValidationAmountFail.localizedString()
            return false
            
        }
        
        guard self.selectedTypeName != Placeholders.NewCategorySelector.localizedString() else {
            self.validationFailed = true
            self.warningMessage = WarningMessages.ValidationCategoryNotSelectedFail.localizedString()
            return false
        }
        return true
    }
}

