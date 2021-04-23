//
//  RoundedRectangleModifier.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-22.
//

import SwiftUI

struct RoundedRectangleModifier: ViewModifier {
    let color: LinearGradient
    let strokeLineWidth: CGFloat
    init(color: LinearGradient, strokeLineWidth: CGFloat) {
        self.color = color
        self.strokeLineWidth = strokeLineWidth
    }
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .opacity(1)
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .opacity(0.7)
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .opacity(0.02)
            }
            content
        }
        
    }
}
