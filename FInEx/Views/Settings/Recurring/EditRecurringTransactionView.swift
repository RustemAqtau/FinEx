//
//  EditRecurringTransactionView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-28.
//

import SwiftUI

struct EditRecurringTransactionView: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var transaction: RecurringTransaction
    
    @State var amount: NSDecimalNumber = 0
    @State private var amountString: String = ""
    @State private var amountIsEditing: Bool = false
    @State var selectedtypeImageName: String = "questionmark"
    @State var selectedTypeCircleColor: String = "TopGradient"
    @State var selectedTypeName: String = NSLocalizedString("Category", comment: "")
    @State var selectedType: TransactionType = TransactionType()
    @State var showCategorySelector: Bool = false
    @State var selectedDate: Date = Date()
    @State var note: String = NSLocalizedString("Note", comment: "")
    @State var noteLenghtLimitOut: Bool = false
    @State var selectedPeriodicity: String = Periodicity.Month.localizedString()
    @State var periodicityList: [String] = []
    let dateRange: ClosedRange<Date>  = getDateRange(for: Date())
    @State var showCalendar: Bool = false
    @State var dayWeekOfMonth: String = ""
    @State var savingFailed: Bool = false
    @State var amountPlaceholder: String = ""
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 20) {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 35.0)
                                .fill(Color.white)
                                .opacity(self.amountIsEditing ? 1 : 0)
                            RoundedRectangle(cornerRadius: 35.0)
                                .stroke(Color.gray)
                                .opacity(self.amountIsEditing ? 1 : 0)
                            TextField(self.amountPlaceholder, text: self.$amountString, onEditingChanged: { isEditing in
                                if isEditing {
                                    self.amountIsEditing = true
                                    //self.amountString = ""
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
                            .padding()
                            
                        }
                        .frame(width: geo.size.width * 0.60, height: 60, alignment: .center)
                    }
                    .frame(width: geo.size.width * 0.60, height: 100, alignment: .center)
                    
                    Divider()
                    
                    VStack(spacing: 10) {
                        Text(LocalizedStringKey("You have already added a recurring for this categoty, please change category."))
                            .font(Fonts.light12)
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .opacity(self.savingFailed ? 1 : 0)
                            .padding(.horizontal)
                        HStack(spacing: 15) {
                            Image(systemName: self.selectedtypeImageName)
                                .foregroundColor(.white)
                                .modifier(CircleModifierSimpleColor(color: Color(self.selectedTypeCircleColor), strokeLineWidth: 3.0))
                                .font(Font.system(size: 22, weight: .regular, design: .default))
                                .frame(width: 45, height: 45, alignment: .center)
                                
                            Text(self.selectedTypeName)
                                .font(Font.system(size: 16, weight: .light, design: .default))
                                .foregroundColor(self.savingFailed ? Color.red : CustomColors.TextDarkGray)
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        .onTapGesture {
                            self.showCategorySelector = true
                        }
                        
                        HStack(spacing: 15) {
                            Image(systemName: "calendar")
                                .foregroundColor(CustomColors.TextDarkGray)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                                .onTapGesture {
                                    self.showCalendar = true
                                }
                            DatePicker(LocalizedStringKey("Start Day"), selection: self.$selectedDate,
                                            in: dateRange,
                                            displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.clear)
                                .foregroundColor(CustomColors.TextDarkGray)
                                .accentColor(CustomColors.TextDarkGray)
                                .shadow(radius: 10.0 )
                                
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        //.padding()
                        
                        HStack(spacing: 15) {
                            Image(systemName: "clock.arrow.2.circlepath")
                                .foregroundColor(CustomColors.TextDarkGray)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                            
                            Picker(self.selectedPeriodicity + self.dayWeekOfMonth,
                                   selection: self.$selectedPeriodicity) {
                                ForEach(self.periodicityList, id: \.self) { periodicity in
                                    Text(periodicity)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .multilineTextAlignment(.center)
                            .frame(width: geo.size.width * 0.65, alignment: .leading)
                            
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        
                        HStack(spacing: 25) {
                            Image(systemName: "pencil")
                                .foregroundColor(CustomColors.TextDarkGray)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
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
                                .foregroundColor(self.noteLenghtLimitOut ? .red : CustomColors.TextDarkGray)
                                .font(Font.system(size: 16, weight: .light, design: .default))
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                self.userSettingsVM.deleteRecurringTransaction(transaction: self.transaction, context: viewContext)
                                
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
                                
                                saveTransaction()
                                
                            }) {
                                SaveButtonView(geo: geo, withTrash: true)
                            }
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .center)
                        
                    }
                    
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .ignoresSafeArea(.all, edges: .bottom)
                
            }
            
            .onAppear {
                var periodicityArray: [String] = []
                for elem in Periodicity.allCases {
                    periodicityArray.append(elem.rawValue)
                }
                self.periodicityList = periodicityArray
                self.amountPlaceholder = userSettingsVM.settings.currencySymbol!
                
                let formatter = setDecimalFormatter(currencySymbol: userSettingsVM.settings.currencySymbol!)
                var amount = formatter.string(from: NSDecimalNumber(decimal: self.transaction.amount! as Decimal))!
                amount.removeFirst()
                self.amountString = amount
                self.selectedType = transaction.type!
                self.selectedTypeName = transaction.type!.presentingName
                self.selectedtypeImageName = transaction.type!.presentingImageName
                self.selectedTypeCircleColor = transaction.type!.presentingColorName
                self.note = transaction.note!
            }
            .onChange(of: self.selectedPeriodicity, perform: { value in
                let format = DateFormatter()
                format.locale = .current
                var dateString: String = ""
                switch self.selectedPeriodicity {
                case Periodicity.Month.localizedString(), Periodicity.Quarter.localizedString():
                    format.dateFormat = "dd"
                    dateString = "day " + format.string(from: self.selectedDate)
                case Periodicity.TwoWeeks.localizedString():
                    format.dateFormat = "EEEE"
                    dateString = format.string(from: self.selectedDate)
                default:
                    format.dateFormat = "MMM-dd"
                    dateString = format.string(from: self.selectedDate)
                }
                
                self.dayWeekOfMonth = ", " + dateString
                
            })
            .sheet(isPresented: self.$showCategorySelector, content: {
                CategotySelector(categoty: self.transaction.category!,
                                 selectedType: self.$selectedType,
                                 selectedtypeImageName: self.$selectedtypeImageName,
                                 selectedTypeCircleColor: self.$selectedTypeCircleColor,
                                 selectedTypeName: self.$selectedTypeName)
            })
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                    .font(Font.system(size: 20, weight: .regular, design: .default))
            })
            .navigationBarTitle (Text(""), displayMode: .inline)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    func saveTransaction() {
        userSettingsVM.getRecurringTransactions(context: viewContext)
        
        if (self.transaction.type != self.selectedType) && userSettingsVM.recurringTransactions.contains(where: { transaction in transaction.type == self.selectedType }) {
            // show Warning
            self.savingFailed = true
        } else {
            let locale = Locale.current
            self.amount = NSDecimalNumber(string: self.amountString, locale: locale)
      
            let newRecurringTransactionInfo = RecurringTransactionInfo(
                startDate: self.selectedDate,
                nextAddingDate: self.selectedDate,
                amount: self.amount,
                note: self.note,
                periodicity: self.selectedPeriodicity,
                type: self.selectedType,
                category: self.transaction.category!)
            self.transaction.edit(info: newRecurringTransactionInfo, context: viewContext)
            presentationMode.wrappedValue.dismiss()
        }
        
       
    }
}
