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
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 45)
                .fill(LinearGradient(gradient: Gradient(colors: [CustomColors.SaveButtonGradient2, CustomColors.SaveButtonGradient1]), startPoint: .bottom, endPoint: .top))
                .shadow(radius: 3)
            Text("Save")
                .foregroundColor(CustomColors.TextDarkGray)
                .font(Font.system(size: 26, weight: .regular, design: .default))
        }
        .frame(width: self.withTrash ? geo.size.width * 0.60 : geo.size.width * 0.80, height: 55, alignment: .center)
    }
}

struct SaveButton_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            SaveButtonView(geo: geo, withTrash: false)
        }
        
    }
}
