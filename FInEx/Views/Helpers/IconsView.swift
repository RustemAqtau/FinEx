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
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(0..<CategoryIcons.first.count) { index in
                        
                        Image(systemName: CategoryIcons.first[index])
                            .foregroundColor(.gray)
                            .frame(width: geo.size.width / 11, height: geo.size.width / 11, alignment: .center)
                            .padding()
                            .onTapGesture {
                                self.appearanceImageName = CategoryIcons.first[index]
                            }
                    }
                }
                HStack(spacing: 0) {
                    ForEach(0..<CategoryIcons.second.count) { index in
                        
                        Image(systemName: CategoryIcons.second[index])
                            .foregroundColor(.gray)
                            .frame(width: geo.size.width / 11, height: geo.size.width / 11, alignment: .center)
                            .padding()
                            .onTapGesture {
                                self.appearanceImageName = CategoryIcons.second[index]
                            }
                    }
                }
                HStack(spacing: 0) {
                    ForEach(0..<CategoryIcons.third.count) { index in
                        
                        Image(systemName: CategoryIcons.third[index])
                            .foregroundColor(.gray)
                            .frame(width: geo.size.width / 11, height: geo.size.width / 11, alignment: .center)
                            .padding()
                            .onTapGesture {
                                
                                self.appearanceImageName = CategoryIcons.third[index]
                            }
                    }
                }
                
            }
            .font(Font.system(size: 24, weight: .regular, design: .default))
        }
        .frame(width: geo.size.width, height: geo.size.height / 2.2, alignment: .leading)
        .position(x: geo.size.width / 2, y: geo.size.height * 0.85)
    }
}

struct IconsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            IconsView(appearanceImageName: .constant(""), geo: geo)
        }
        
    }
}
