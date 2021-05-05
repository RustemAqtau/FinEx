//
//  SaveButton.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-16.
//

import SwiftUI

struct SaveButtonView: View {
    let geo: GeometryProxy
    let withTrash: Bool
    let withdraw: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 45)
                .fill(withdraw ? GradientColors.WithdrawButton : GradientColors.SaveButton)
                .shadow(radius: 3)
            Text(withdraw ? LocalizedStringKey(LableTitles.withdrawButton.localizedString()) : LocalizedStringKey(LableTitles.saveButton.localizedString()))
                .foregroundColor(CustomColors.TextDarkGray)
                .font(Font.system(size: 26, weight: .regular, design: .default))
        }
        .frame(width: self.withTrash ? geo.size.width * 0.60 : geo.size.width * 0.90, height: 55, alignment: .center)
    }
}


