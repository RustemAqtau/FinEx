//
//  SettingsView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-07.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @State var offsetY: CGFloat = -5.0
    let coloredNavAppearance = UINavigationBarAppearance()
    let coloredBarButtonAppearance = UIBarButtonItemAppearance ()
    
    @Binding var  hideTabBar: Bool
    @Binding var themeColorChanged: Bool
    @Binding var themeColor: LinearGradient
    @Binding var currencySymbolChanged: Bool
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                }
                .frame(width: geo.size.width, height: geo.size.height / 7, alignment: .center)
                .background(Color.white)
                .ignoresSafeArea(.all, edges: .top)
                .navigationBarTitle (Text(LocalizedStringKey("TOOLS")), displayMode: .inline)
                .zIndex(100)
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        HStack(spacing: 20) {
                            NavigationLink(
                                destination: RegisterWithAppleID(hideTabBar: self.$hideTabBar)
                                    .environmentObject(userSettingsVM)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .fill(Color.white)
                                    .shadow(radius: 6)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(Color.white)
                                VStack(spacing: 15) {
                                    Image(systemName: "arrow.clockwise.icloud.fill")
                                        .font(Font.system(size: 40, weight: .light, design: .default))
                                        .foregroundColor(CustomColors.ExpensesColor2)
                                        .frame(height: 50)
                                        
                                    VStack(alignment: .center, spacing: 8) {
                                        Text(LocalizedStringKey(LableTitles.registerTab.localizedString()))
                                            .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                        Text(LocalizedStringKey(SettingsContentDescription.registerTab_mainDescription.localizedString()))
                                            .font(Font.system(size: 13, weight: .light, design: .rounded))
                                    }
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .lineLimit(4)
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .top)
                                    .padding(.horizontal)
                                    .frame(height: 90, alignment: .top)
                                    
                               }
                            }
                            .padding(.vertical)
                            .frame(height: 210, alignment: .top)
                            }
                            NavigationLink(
                                destination: PasscodeView(hideTabBar: self.$hideTabBar)) {
                                ZStack {
                                     RoundedRectangle(cornerRadius: 25.0)
                                         .fill(Color.white)
                                         .shadow(radius: 6)
                                     RoundedRectangle(cornerRadius: 25.0)
                                         .stroke(Color.white)
                                     VStack(spacing: 15) {
                                         Image(systemName: "lock.shield")
                                             .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor2)
                                            .frame(height: 50)
                                            
                                         VStack(alignment: .center, spacing: 8) {
                                             Text(LocalizedStringKey(LableTitles.passcodeTab.localizedString()))
                                                .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                            Text(LocalizedStringKey(SettingsContentDescription.passcodeTab_mainDescription.localizedString()))
                                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                         }
                                         .multilineTextAlignment(.center)
                                         .foregroundColor(CustomColors.TextDarkGray)
                                         .lineLimit(4)
                                         .frame(maxWidth: .greatestFiniteMagnitude, alignment: .top)
                                         .padding(.horizontal)
                                         .frame(height: 90, alignment: .top)
                                         
                                    }
                                 }
                                .padding(.vertical)
                                .frame(height: 210, alignment: .top)
                            }
                           
                        }
                        .padding(.horizontal)
                        .offset(y: offsetY)
                        HStack(spacing: 20) {
                            NavigationLink(
                                destination: EditCategories(hideTabBar: self.$hideTabBar)
                                    .environmentObject(userSettingsVM)
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(Color.white)
                                        .shadow(radius: 6)
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(Color.white)
                                    VStack(spacing: 15) {
                                        Image(systemName: "tag.circle")
                                            .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor2)
                                            .frame(height: 50)
                                        VStack(alignment: .center, spacing: 8) {
                                            Text(LocalizedStringKey(LableTitles.categoriesTab.localizedString()))
                                                .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                            Text(LocalizedStringKey(SettingsContentDescription.categoriesTab_mainDescription.localizedString()))
                                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                                
                                        }
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .lineLimit(4)
                                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
                                        .padding(.horizontal)
                                        .frame(height: 90, alignment: .top)
                                        
                                   }
                                }
                                .padding(.vertical)
                                .frame(height: 210, alignment: .top)
                                }
                            
                            NavigationLink(
                                destination: RecurringTransactionsView(hideTabBar: self.$hideTabBar)
                                    .environmentObject(userSettingsVM)
                            ) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .fill(Color.white)
                                    .shadow(radius: 6)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(Color.white)
                                VStack(spacing: 15) {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(Font.system(size: 40, weight: .light, design: .default))
                                        .foregroundColor(CustomColors.ExpensesColor2)
                                        .frame(height: 50)
                                    VStack(alignment: .center, spacing: 8) {
                                        Text(LocalizedStringKey(LableTitles.recurringTab.localizedString()))
                                            .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                        Text(LocalizedStringKey(SettingsContentDescription.recurringTab_mainDescription.localizedString()))
                                            .font(Font.system(size: 13, weight: .light, design: .rounded))
                                            
                                    }
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 13, weight: .light, design: .rounded))
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .lineLimit(4)
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
                                    .padding(.horizontal)
                                    .frame(height: 90, alignment: .top)
                                    
                               }
                            }
                            .padding(.vertical)
                            .frame(height: 210, alignment: .top)
                        }
                        }
                        .padding(.horizontal)
                        .offset(y: offsetY)
                        HStack(spacing: 20) {
                            NavigationLink(
                                destination: AppearanceView(hideTabBar: self.$hideTabBar,
                                                            themeColorChanged: self.$themeColorChanged, currencySymbolChanged: self.$currencySymbolChanged)
                                    .environment(\.userSettingsVM, self.userSettingsVM)
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(Color.white)
                                        .shadow(radius: 6)
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(Color.white)
                                    VStack(spacing: 15) {
                                        Image(systemName: "viewfinder.circle")
                                            .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor2)
                                            .frame(height: 50)
                                        VStack(alignment: .center, spacing: 8) {
                                            Text(LocalizedStringKey(LableTitles.appearanceTab.localizedString()))
                                                .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                            Text(LocalizedStringKey(SettingsContentDescription.appearanceTab_mainDescription.localizedString()))
                                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                                
                                        }
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .lineLimit(4)
                                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
                                        .padding(.horizontal)
                                        .frame(height: 90, alignment: .top)
                                        
                                   }
                                }
                                .padding(.vertical)
                                .frame(height: 210, alignment: .top)
                            }
                            
                            NavigationLink(
                                destination: RemaindersView(hideTabBar: self.$hideTabBar)
                                    .environment(\.userSettingsVM, userSettingsVM)
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(Color.white)
                                        .shadow(radius: 6)
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(Color.white)
                                    VStack(spacing: 15) {
                                        Image(systemName: "bell.circle")
                                            .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor2)
                                            .frame(height: 50)
                                        VStack(alignment: .center, spacing: 8) {
                                            Text(LocalizedStringKey(LableTitles.remainderTab.localizedString()))
                                                .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                            Text(LocalizedStringKey(SettingsContentDescription.reminderTab_mainDescription.localizedString()))
                                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                                
                                        }
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .lineLimit(4)
                                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
                                        .padding(.horizontal)
                                        .frame(height: 90, alignment: .top)
                                   }
                                }
                                .padding(.vertical)
                                .frame(height: 210, alignment: .top)
                            }
                            
                        }
                        .padding(.horizontal)
                        .offset(y: offsetY)
                        //.offset(y: 10.0)
                    }
                    .frame(width: geo.size.width , alignment: .center)
                    .onAppear {
                        setNavBarAppearance()
                        startAnimate()
                    }

                    VStack {
                    }
                    .frame(width: geo.size.width, height: 100, alignment: .center)
                }
            }
            .background(Color.white)
            
        }
        .accentColor(CustomColors.TextDarkGray)
        .navigationBarBackButtonHidden(true)
        //.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    func startAnimate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.offsetY = 20.0
        }
    }
    
    func setNavBarAppearance() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(.clear) //UIColor(CustomColors.TopBackgroundGradient3)
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor(CustomColors.TextDarkGray), .strokeColor: UIColor.clear, .underlineColor: UIColor.clear]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.gray]
        coloredNavAppearance.shadowColor = .clear
        
        coloredBarButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(CustomColors.TextDarkGray)]
        coloredNavAppearance.backButtonAppearance = coloredBarButtonAppearance
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        UINavigationBar.appearance().standardAppearance.doneButtonAppearance = coloredBarButtonAppearance
        UINavigationBar.appearance().compactAppearance?.doneButtonAppearance = coloredBarButtonAppearance
        UINavigationBar.appearance().standardAppearance.backButtonAppearance = coloredBarButtonAppearance
        UINavigationBar.appearance().compactAppearance?.backButtonAppearance = coloredBarButtonAppearance
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
