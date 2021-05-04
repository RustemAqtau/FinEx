//
//  NoDataPlaceholderView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-05-03.
//

import SwiftUI

struct NoDataPlaceholderView: View {
    var body: some View {
        VStack {
            Text("🤷")
                .modifier(CircleModifier(color: GradientColors.TabBarBackground, strokeLineWidth: 2))
                .font(Fonts.light40)
                .frame(width: 90, height: 90, alignment: .center)
            Text("There is no transactions for this month.")
                .foregroundColor(.gray)
                .font(Fonts.light15)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
}

struct NoDataPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataPlaceholderView()
    }
}
