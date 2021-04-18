//
//  CircleModifier.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-07.
//

import SwiftUI

struct CircleModifier: ViewModifier {
    
    let color: LinearGradient
    let strokeLineWidth: CGFloat
    init(color: LinearGradient, strokeLineWidth: CGFloat) {
        self.color = color
        self.strokeLineWidth = strokeLineWidth
    }
    func body(content: Content) -> some View {
        ZStack {
            Group {
                Circle()
                    .fill(Color.white)
                    .opacity(1)
                Circle()
                    //.fill(LinearGradient(gradient: Gradient(colors: [Color("ToolsIconsGradient1"), Color("ToolsIconsGradient2")]), startPoint: .bottomLeading, endPoint: .topLeading))
                    .fill(color)
                    .opacity(0.7)
                Circle()
                    .fill(Color.white)
                    .opacity(0.02)
                Circle()
                    .stroke(lineWidth: strokeLineWidth).foregroundColor(.white)
                    .shadow(radius: 10)
            }
            content
        }
        
    }
}

struct CircleModifierSimpleColor: ViewModifier {
    
    let color: Color
    let strokeLineWidth: CGFloat
    init(color: Color, strokeLineWidth: CGFloat) {
        self.color = color
        self.strokeLineWidth = strokeLineWidth
    }
    func body(content: Content) -> some View {
        ZStack {
            Group {
                Circle()
                    .fill(Color.white)
                    .opacity(0.9)
                Circle()
                    //.fill(LinearGradient(gradient: Gradient(colors: [Color("ToolsIconsGradient1"), Color("ToolsIconsGradient2")]), startPoint: .bottomLeading, endPoint: .topLeading))
                    .fill(color)
                    .opacity(0.7)
                Circle()
                    .fill(Color.white)
                    .opacity(0.02)
                Circle()
                    .stroke(lineWidth: strokeLineWidth).foregroundColor(.white)
                    .shadow(radius: 10)
            }
            content
        }
        
    }
}
