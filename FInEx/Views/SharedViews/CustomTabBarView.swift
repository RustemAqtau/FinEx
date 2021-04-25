//
//  CustomTabBarView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-07.
//

import SwiftUI

struct CustomTabBarView: View {
    let geo: GeometryProxy
    @Binding var plusButtonColor: Color
    @Binding var isBudgetView: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [CustomColors.TopColorGradient2, Color.white]), startPoint: .bottomLeading, endPoint: .topLeading))
                .frame(width: geo.size.width, height: 120, alignment: .center)
            
            Button(action: {}, label: {
            Image(systemName: "plus")
            })
            .modifier(CircleModifierSimpleColor(color: self.plusButtonColor, strokeLineWidth: 3.0))
            .opacity(1)
            .frame(width: geo.size.width / 5, height: geo.size.height / 8, alignment: .center)
            .position(x: geo.size.width / 2, y: geo.size.height / 2.3)
            
            HStack(alignment: .top , spacing: geo.size.width / 2) {
                Button(action: {}, label: {
                    
                Image(systemName: "chart.bar.xaxis")
               })
                
                NavigationLink(destination: SettingsView() ) {
                    Image(systemName: "wrench")
                }
            }
            .foregroundColor(.gray)
            .font(Font.system(size: 30, weight: .medium, design: .default))
            .position(x: geo.size.width / 2, y: geo.size.height / 2.1)
        }
        .position(x: geo.size.width / 2, y: geo.size.height)
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            CustomTabBarView(geo: geo, plusButtonColor: .constant(Color.yellow), isBudgetView: .constant(false))
        }
        
    }
}
