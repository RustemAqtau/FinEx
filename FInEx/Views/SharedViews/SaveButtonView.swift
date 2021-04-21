//
//  SaveButton.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-16.
//

import SwiftUI

struct SaveButtonView: View {
    let geo: GeometryProxy
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 45)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("SaveButtonGradient2"), Color("SaveButtonGradient1")]), startPoint: .bottom, endPoint: .top))
                .shadow(radius: 5)
            Text("Save")
                .foregroundColor(Color("TextDarkGray"))
                .font(Font.system(size: 26, weight: .regular, design: .default))
        }
        .frame(width: geo.size.width * 0.80, height: 55, alignment: .center)
    }
}

struct SaveButton_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            SaveButtonView(geo: geo)
        }
        
    }
}
