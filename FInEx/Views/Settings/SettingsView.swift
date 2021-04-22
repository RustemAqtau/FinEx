//
//  SettingsView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-07.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    let tools = ["Register", "Passcode", "Categories", "Recurring", "Appearance", "Remainder"]
    let coloredNavAppearance = UINavigationBarAppearance()
    let coloredBarButtonAppearance = UIBarButtonItemAppearance ()
    @State var offsetY: CGFloat = -5.0
    
    init() {
        setNavBarAppearance()
        
    }
    var body: some View {
        NavigationView {
            
            GeometryReader { geo in
                
                VStack {
                    //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
                .frame(width: geo.size.width, height: geo.size.height / 6, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [Color("TopGradient"), Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
                .ignoresSafeArea(.all, edges: .top)
                .navigationBarTitle (Text("TOOLS"), displayMode: .inline)
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        HStack(spacing: 20) {
                            NavigationLink(
                                destination: RegisterWithAppleID()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .fill(Color.white)
                                    .shadow(radius: 6)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(Color.white)
                                VStack(spacing: 0) {
                                    Image(systemName: "arrow.clockwise.icloud.fill")
                                        .font(Font.system(size: 40, weight: .light, design: .default))
                                        .foregroundColor(Color("ExpensesColor"))
                                    VStack(alignment: .center, spacing: 4) {
                                        Text("REGISTER")
                                        Text("Secure your data in the cloud and use multiple devices")
                                            .font(Font.system(size: 15, weight: .light, design: .rounded))
                                    }
                                    
                                    .foregroundColor(Color("TextDarkGray"))
                                    .lineLimit(3)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                               }
                            }
                            }.opacity(userSettingsVM.settings.isSignedWithAppleId ? 0 : 1)
                            NavigationLink(
                                destination: PasscodeView()) {
                                ZStack {
                                     RoundedRectangle(cornerRadius: 25.0)
                                         .fill(Color.white)
                                         .shadow(radius: 6)
                                     RoundedRectangle(cornerRadius: 25.0)
                                         .stroke(Color.white)
                                     VStack(spacing: 0) {
                                         Image(systemName: "lock.shield")
                                             .font(Font.system(size: 40, weight: .light, design: .default))
                                             .foregroundColor(Color("ExpensesColor"))
                                         VStack(alignment: .center, spacing: 4) {
                                             Text("PASSCODE")
                                             Text("Protect your data with a passcode.")
                                                 .font(Font.system(size: 15, weight: .light, design: .rounded))
                                         }
                                         
                                         .foregroundColor(Color("TextDarkGray"))
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
                                destination: EditCategories()
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
                                            .foregroundColor(Color("ExpensesColor"))
                                        VStack(alignment: .center, spacing: 4) {
                                            Text("CATEGORIES")
                                            Text("Create, edit or remove any of your categories")
                                                .font(Font.system(size: 15, weight: .light, design: .rounded))
                                        }
                                        
                                        .foregroundColor(Color("TextDarkGray"))
                                        .lineLimit(3)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                   }
                                }
                                }
                            
                            NavigationLink(
                                destination: RecurringTransactionsView()
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
                                        .foregroundColor(Color("ExpensesColor"))
                                    VStack(alignment: .center, spacing: 4) {
                                        Text("RECURRING")
                                        Text("Manage your regular transactions")
                                            .font(Font.system(size: 15, weight: .light, design: .rounded))
                                    }
                                    
                                    .foregroundColor(Color("TextDarkGray"))
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
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .fill(Color.white)
                                    .shadow(radius: 6)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(Color.white)
                                VStack(spacing: 0) {
                                    Image(systemName: "lock.shield")
                                        .font(Font.system(size: 40, weight: .light, design: .default))
                                        .foregroundColor(Color("ExpensesColor"))
                                    VStack(alignment: .center, spacing: 4) {
                                        Text("REGISTER")
                                        Text("Secure your data in the cloud and use multiple devices")
                                            .font(Font.system(size: 15, weight: .light, design: .rounded))
                                    }
                                    
                                    .foregroundColor(Color("TextDarkGray"))
                                    .lineLimit(3)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
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
                                        .foregroundColor(Color("ExpensesColor"))
                                    VStack(alignment: .center, spacing: 4) {
                                        Text("REGISTER")
                                        Text("Secure your data in the cloud and use multiple devices")
                                            .font(Font.system(size: 15, weight: .light, design: .rounded))
                                    }
                                    
                                    .foregroundColor(Color("TextDarkGray"))
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
                        startAnimate()
                    }
                }
                
            }
            .background(Color.white)
            
        }
        .accentColor(Color("TextDarkGray"))
        //.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    func startAnimate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.offsetY = 10.0
        }
    }
    
    func setNavBarAppearance() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(.clear)
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.gray, .strokeColor: UIColor.clear, .underlineColor: UIColor.clear]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.gray]
        coloredNavAppearance.shadowColor = .clear
        coloredBarButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color("TextDarkGray"))]
        
        
        coloredNavAppearance.backButtonAppearance = coloredBarButtonAppearance
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        UINavigationBar.appearance().standardAppearance.doneButtonAppearance = coloredBarButtonAppearance
        UINavigationBar.appearance().compactAppearance?.doneButtonAppearance = coloredBarButtonAppearance
        UINavigationBar.appearance().standardAppearance.backButtonAppearance = coloredBarButtonAppearance
        UINavigationBar.appearance().compactAppearance?.backButtonAppearance = coloredBarButtonAppearance
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
