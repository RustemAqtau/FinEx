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

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                }
                .frame(width: geo.size.width, height: geo.size.height / 7, alignment: .center)
                .background(themeColor)
                .ignoresSafeArea(.all, edges: .top)
                .navigationBarTitle (Text(LocalizedStringKey("TOOLS")), displayMode: .inline)
                .zIndex(100)
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        HStack(spacing: 20) {
                            NavigationLink(
                                destination: RegisterWithAppleID(hideTabBar: self.$hideTabBar)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .fill(Color.white)
                                    .shadow(radius: 6)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(Color.white)
                                VStack(spacing: 20) {
                                    Image(systemName: "arrow.clockwise.icloud.fill")
                                        .font(Font.system(size: 40, weight: .light, design: .default))
                                        .foregroundColor(CustomColors.ExpensesColor)
                                        .frame(height: 50)
                                        
                                    VStack(alignment: .center, spacing: 8) {
                                        Text(LocalizedStringKey("REGISTER"))
                                            .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                        Text(LocalizedStringKey("Secure your data in the cloud and use multiple devices"))
                                            .font(Font.system(size: 13, weight: .light, design: .rounded))
                                    }
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .lineLimit(3)
                                    .frame(maxWidth: .infinity, alignment: .top)
                                    .padding(.horizontal)
                                    .frame(height: 90, alignment: .top)
                                    
                               }
                            }
                            .padding(.vertical)
                            .frame(height: 210, alignment: .top)
                            }
                            //.opacity(userSettingsVM.settings.isSignedWithAppleId ? 0 : 1)
                            NavigationLink(
                                destination: PasscodeView(hideTabBar: self.$hideTabBar)) {
                                ZStack {
                                     RoundedRectangle(cornerRadius: 25.0)
                                         .fill(Color.white)
                                         .shadow(radius: 6)
                                     RoundedRectangle(cornerRadius: 25.0)
                                         .stroke(Color.white)
                                     VStack(spacing: 20) {
                                         Image(systemName: "lock.shield")
                                             .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor)
                                            .frame(height: 50)
                                            
                                         VStack(alignment: .center, spacing: 8) {
                                             Text(LocalizedStringKey("PASSCODE"))
                                                .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                             Text(LocalizedStringKey("Protect your data with a passcode."))
                                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                         }
                                         .multilineTextAlignment(.center)
                                         .foregroundColor(CustomColors.TextDarkGray)
                                         .lineLimit(3)
                                         .frame(maxWidth: .infinity, alignment: .top)
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
                                    VStack(spacing: 20) {
                                        Image(systemName: "tag.circle")
                                            .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor)
                                            .frame(height: 50)
                                        VStack(alignment: .center, spacing: 8) {
                                            Text(LocalizedStringKey("CATEGORIES"))
                                                .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                            Text(LocalizedStringKey("Create, edit or remove any of your categories"))
                                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                                
                                        }
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .lineLimit(3)
                                        .frame(maxWidth: .infinity, alignment: .center)
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
                                VStack(spacing: 20) {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(Font.system(size: 40, weight: .light, design: .default))
                                        .foregroundColor(CustomColors.ExpensesColor)
                                        .frame(height: 50)
                                    VStack(alignment: .center, spacing: 8) {
                                        Text(LocalizedStringKey("RECURRING"))
                                            .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                        Text(LocalizedStringKey("Manage your regular transactions"))
                                            .font(Font.system(size: 13, weight: .light, design: .rounded))
                                            
                                    }
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 13, weight: .light, design: .rounded))
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .lineLimit(3)
                                    .frame(maxWidth: .infinity, alignment: .center)
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
                                                            themeColorChanged: self.$themeColorChanged)
                                    .environment(\.userSettingsVM, self.userSettingsVM)
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(Color.white)
                                        .shadow(radius: 6)
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(Color.white)
                                    VStack(spacing: 20) {
                                        Image(systemName: "lock.shield")
                                            .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor)
                                            .frame(height: 50)
                                        VStack(alignment: .center, spacing: 8) {
                                            Text(LocalizedStringKey("APPEARANCE"))
                                                .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                            Text(LocalizedStringKey("Customize the app to suit you"))
                                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                                
                                        }
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .lineLimit(3)
                                        .frame(maxWidth: .infinity, alignment: .center)
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
                                    VStack(spacing: 20) {
                                        Image(systemName: "lock.shield")
                                            .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor)
                                            .frame(height: 50)
                                        VStack(alignment: .center, spacing: 8) {
                                            Text(LocalizedStringKey("REMAINDER"))
                                                .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                            Text(LocalizedStringKey("Set up reminders and get notified when it suits you"))
                                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                                
                                        }
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .lineLimit(3)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.horizontal)
                                        .frame(height: 90, alignment: .top)
                                   }
                                }
                                .padding(.vertical)
                                .frame(height: 210, alignment: .top)
                            }
                            
                        }
                        .padding(.horizontal)
                        //.offset(y: offsetY)
                        .offset(y: 10.0)
                    }
                    .frame(width: geo.size.width , alignment: .center)
                    .onAppear {
                        setNavBarAppearance()
                        startAnimate()
                        self.hideTabBar = false
                    }
                    VStack {
                    }
                    .frame(width: geo.size.width, height: 100, alignment: .center)
                }
            }
            .background(Color.white)
            
        }
        .accentColor(CustomColors.TextDarkGray)
        //.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    func startAnimate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.offsetY = 10.0
        }
    }
    
    func setNavBarAppearance() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(.clear) //UIColor(CustomColors.TopBackgroundGradient3)
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.gray, .strokeColor: UIColor.clear, .underlineColor: UIColor.clear]
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
