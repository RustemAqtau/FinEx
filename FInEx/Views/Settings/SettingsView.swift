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
//    init() {
//        setNavBarAppearance()
//
//    }
    var body: some View {
        NavigationView {
            
            GeometryReader { geo in
                
                VStack {
                    //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
                .frame(width: geo.size.width, height: geo.size.height / 6, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [CustomColors.TopColorGradient2, Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
                .ignoresSafeArea(.all, edges: .top)
                .navigationBarTitle (Text(LocalizedStringKey("TOOLS")), displayMode: .inline)
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
                                VStack(spacing: 10) {
                                    Image(systemName: "arrow.clockwise.icloud.fill")
                                        .font(Font.system(size: 40, weight: .light, design: .default))
                                        .foregroundColor(CustomColors.ExpensesColor)
                                    
                                    VStack(alignment: .center, spacing: 4) {
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
                               }
                            }
                            //.frame(width: 140, height: 190, alignment: .top)
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
                                     VStack(spacing: 10) {
                                         Image(systemName: "lock.shield")
                                             .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor)
                                         VStack(alignment: .center, spacing: 4) {
                                             Text(LocalizedStringKey("PASSCODE"))
                                                .font(Font.system(size: 13, weight: .regular, design: .rounded))
                                             Text(LocalizedStringKey("Protect your data with a passcode."))
                                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                         }
                                         .multilineTextAlignment(.center)
                                         
                                         .foregroundColor(CustomColors.TextDarkGray)
                                         .lineLimit(3)
                                         .frame(maxWidth: .infinity, alignment: .top)
                                         .padding()
                                    }
                                 }
                            }
                           
                        }
                        .padding()
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
                                    VStack(spacing: 0) {
                                        Image(systemName: "tag.circle")
                                            .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor)
                                        VStack(alignment: .center, spacing: 4) {
                                            Text(LocalizedStringKey("CATEGORIES"))
                                            Text(LocalizedStringKey("Create, edit or remove any of your categories"))
                                                
                                        }
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .lineLimit(3)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                   }
                                }
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
                                VStack(spacing: 0) {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(Font.system(size: 40, weight: .light, design: .default))
                                        .foregroundColor(CustomColors.ExpensesColor)
                                    VStack(alignment: .center, spacing: 4) {
                                        Text(LocalizedStringKey("RECURRING"))
                                        Text(LocalizedStringKey("Manage your regular transactions"))
                                            
                                    }
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 13, weight: .light, design: .rounded))
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .lineLimit(3)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                               }
                            }
                        }
                        }
                        .padding()
                        .offset(y: offsetY)
                        HStack(spacing: 20) {
                            NavigationLink(
                                destination: AppearanceView(hideTabBar: self.$hideTabBar)
                                    .environment(\.userSettingsVM, self.userSettingsVM)
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(Color.white)
                                        .shadow(radius: 6)
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(Color.white)
                                    VStack(spacing: 0) {
                                        Image(systemName: "lock.shield")
                                            .font(Font.system(size: 40, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.ExpensesColor)
                                        VStack(alignment: .center, spacing: 4) {
                                            Text(LocalizedStringKey("APPEARANCE"))
                                            Text(LocalizedStringKey("-"))
                                                
                                        }
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .lineLimit(3)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                   }
                                }
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .fill(Color.white)
                                    .shadow(radius: 6)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(Color.white)
                                VStack(spacing: 0) {
                                    Image(systemName: "lock.shield")
                                        .font(Font.system(size: 40, weight: .light, design: .default))
                                        .foregroundColor(CustomColors.ExpensesColor)
                                    VStack(alignment: .center, spacing: 4) {
                                        Text(LocalizedStringKey("REGISTER"))
                                        Text(LocalizedStringKey("Secure your data in the cloud and use multiple devices"))
                                            
                                    }
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 13, weight: .light, design: .rounded))
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .lineLimit(3)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                               }
                            }
                        }
                        .padding()
                        .offset(y: offsetY)
                        
                    }
                    .frame(width: geo.size.width , height: geo.size.height * 0.95, alignment: .center)
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
