//
//  IconsView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-08.
//

import SwiftUI

struct IconsView: View {
    @Binding var appearanceImageName: String
    let geo: GeometryProxy
    var body: some View {
        ScrollView(.horizontal){
            ZStack {
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.4)
                    
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0..<CategoryIcons.first.count) { index in
                            
                            Image(CategoryIcons.first[index])
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding()
                                .onTapGesture {
                                    self.appearanceImageName = CategoryIcons.first[index]
                                }
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(0..<CategoryIcons.second.count) { index in
                            
                            Image(CategoryIcons.second[index])
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding()
                                .onTapGesture {
                                    self.appearanceImageName = CategoryIcons.second[index]
                                }
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(0..<CategoryIcons.third.count) { index in
                            
                            Image(CategoryIcons.third[index])
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding()
                                .onTapGesture {
                                    
                                    self.appearanceImageName = CategoryIcons.third[index]
                                }
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(0..<CategoryIcons.forth.count) { index in
                            
                            Image(CategoryIcons.forth[index])
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding()
                                .onTapGesture {
                                    
                                    self.appearanceImageName = CategoryIcons.forth[index]
                                }
                        }
                    }
                    
                }
                //.font(Font.system(size: 24, weight: .regular, design: .default))
               
            }
            
    
        }
        .frame(width: geo.size.width, height: geo.size.height / 2.5, alignment: .topLeading)
        .position(x: geo.size.width / 2, y: geo.size.height * 0.80)
    }
}

struct IconsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            IconsView(appearanceImageName: .constant(""), geo: geo)
        }
        
    }
}
