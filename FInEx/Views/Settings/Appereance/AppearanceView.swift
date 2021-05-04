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
    @State var showDecimals: Bool = false
    @Binding var  hideTabBar: Bool
    @Binding var themeColorChanged: Bool
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {

                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .frame(width: geo.size.width, height: 80, alignment: .leading)
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Currency Symbol".uppercased())
                                            .font(Fonts.light12)
                                            .foregroundColor(CustomColors.TextDarkGray)
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
                                            .foregroundColor(CustomColors.TextDarkGray)
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
                        }
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .frame(width: geo.size.width, height: 80, alignment: .leading)
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Currency".uppercased())
                                        .font(Fonts.light12)
                                        .foregroundColor(CustomColors.TextDarkGray)
                                    Toggle(isOn: self.$showDecimals, label: {
                                        HStack {
                                            Text("Show double decimals")
                                                .foregroundColor(CustomColors.TextDarkGray)
                                                .font(Fonts.light20)
                                        }
                                    })
                                }
                            }
                            .padding(.horizontal)
                            .frame(width: geo.size.width, height: 50, alignment: .leading)
                        }
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .frame(width: geo.size.width, height: 80, alignment: .leading)
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Color theme".uppercased())
                                            .font(Fonts.light12)
                                    }
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    HStack {
                                        ForEach(Theme.colors.keys.sorted(), id: \.self) { theme in
                                            Text("")
                                                .modifier(CircleModifier(color: Theme.colors[theme]!, strokeLineWidth: 2))
                                                .frame(width: geo.size.width / 11, height: geo.size.width / 11, alignment: .center)
                                                .onTapGesture {
                                                    self.hideTabBar = true
                                                    self.userSettingsVM.settings.editColorTheme(value: theme, context: viewContext)
                                                    self.themeColorChanged.toggle()
                                                }
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            .frame(width: geo.size.width, height: 50, alignment: .leading)
                        }
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
                    .navigationBarTitle (Text(""), displayMode: .inline)
                    .onAppear{
                        self.hideTabBar = true
                        if let symbol = userSettingsVM.settings.currencySymbol {
                            self.selectedCurrencySymbol = symbol
                            setCurrencyName()
                        }
                        
                        self.showDecimals = self.userSettingsVM.settings.showDecimals
                    }
                    .onChange(of: self.selectedCurrencySymbol, perform: { value in
                        userSettingsVM.settings.editCurrencySymbol(value: value, context: viewContext)
                        setCurrencyName()
                    })
                    .onChange(of: self.showDecimals, perform: { value in
                        self.userSettingsVM.settings.editShowDecimals(value: value, context: viewContext)
                    })
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .onTapGesture {
                    self.hideTabBar = true
                }
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
        default: self.currencyName = "Currency"
        }
    }
}
