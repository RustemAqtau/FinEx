//
//  CustomTabBarView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-07.
//

import SwiftUI

struct CustomTabBarView: View {
    //let geo: GeometryProxy
    @Binding var plusButtonColor: LinearGradient
    @Binding var isBudgetView: Bool
    
    @Binding var mainButtonTapped: Bool
    @Binding var isAnalyticsView: Bool
    @Binding var isSettingsView: Bool
    @Binding var toolsButtonTapped: Bool
    @Binding var analyticsButtonTapped: Bool
    var body: some View {
        GeometryReader { proxi in
            ZStack {
                Rectangle()
                    .fill(GradientColors.TabBarBackground)
                    .frame(width: proxi.size.width, height: 120, alignment: .center)
                
                Button(action: {
                    self.mainButtonTapped.toggle()
                }, label: {
                    Image(systemName: (self.isAnalyticsView || self.isSettingsView) ? "house.fill" : "plus")
                })
                .foregroundColor(.white)
                .modifier(CircleModifier(color: self.plusButtonColor, strokeLineWidth: 3.0))
                .opacity(0.8)
                .frame(width: proxi.size.width / 5, height: proxi.size.height / 8, alignment: .center)
                .position(x: proxi.size.width / 2, y: proxi.size.height / 2.3)
                
                HStack(alignment: .top , spacing: proxi.size.width / 2) {
                    
                    Button(action: {
                        self.analyticsButtonTapped.toggle()
                    }, label: {
                        Image(systemName: "circle.grid.cross")
                    })
                    Button(action: {
                        self.toolsButtonTapped.toggle()
                    }, label: {
                        Image(systemName: "wrench")
                    })
                }
                .foregroundColor(.gray)
                .position(x: proxi.size.width / 2, y: proxi.size.height / 2.1)
            }
            .font(Font.system(size: 30, weight: .medium, design: .default))
            .position(x: proxi.size.width / 2, y: proxi.size.height)
            .onAppear {
                print("geo.height: \(proxi.size.height)")
            }
        }
        
    }
}

