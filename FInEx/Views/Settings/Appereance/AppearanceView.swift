//
//  AppearanceView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-26.
//

import SwiftUI

struct AppearanceView: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedCurrencySymbol: String = ""
    @State var currencyName: String = ""
    @Binding var  hideTabBar: Bool
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack(alignment: .leading) {
                    HStack {
                        
                    }
                    .padding(.horizontal)
                    .frame(width: geo.size.width, height: 50, alignment: .leading)
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Currency Symbol".uppercased())
                                    .font(Fonts.light12)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(Color.red)
                                    Picker(LocalizedStringKey("CHANGE"),
                                           selection: self.$selectedCurrencySymbol) {
                                        ForEach(CurrencySymbols.allCases, id: \.self) { symbol in
                                            Text(LocalizedStringKey(symbol.rawValue)).tag(symbol.rawValue)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .font(Font.system(size: 12, weight: .light, design: .default))
                                }
                                .frame(width: geo.size.width / 4, height: 20, alignment: .center)
                            }
                            
                            HStack {
                                Text(self.selectedCurrencySymbol)
                                    .modifier(CircleModifier(color: GradientColors.Home, strokeLineWidth: 2))
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 20, weight: .regular, design: .default))
                                    .frame(width: geo.size.width / 12, height: geo.size.width / 11, alignment: .center)
                                Text(self.currencyName)
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .font(Fonts.light20)
                                
                            }
                            
                        }
                        
                    }
                    .padding(.horizontal)
                    .frame(width: geo.size.width, height: 50, alignment: .leading)
                    Divider()
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
                .navigationBarTitle (Text(LocalizedStringKey("")), displayMode: .inline)
                .onAppear{
                    if let symbol = userSettingsVM.settings.currencySymbol {
                        self.selectedCurrencySymbol = symbol
                        setCurrencyName()
                    }
                    
                    self.hideTabBar = true
                    
                }
                .onChange(of: self.selectedCurrencySymbol, perform: { value in
                    userSettingsVM.settings.changeCurrencySymbol(value: self.selectedCurrencySymbol, context: viewContext)
                    setCurrencyName()
                })
            }
        }
    }
    private func setCurrencyName() {
        switch self.selectedCurrencySymbol {
        case CurrencySymbols.dollar.rawValue: self.currencyName = "Dollar"
        case CurrencySymbols.euro.rawValue: self.currencyName = "Euro"
        case CurrencySymbols.lira.rawValue: self.currencyName = "Lira"
        case CurrencySymbols.pound.rawValue: self.currencyName = "Pound"
        case CurrencySymbols.ruble.rawValue: self.currencyName = "Ruble"
        case CurrencySymbols.tenge.rawValue: self.currencyName = "Tenge"
        case CurrencySymbols.yen.rawValue: self.currencyName = "Yen"
        default: self.currencyName = "Dollar"
        }
    }
}
