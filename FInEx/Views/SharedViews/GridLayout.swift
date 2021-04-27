//
//  GridLayout.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-15.
//

import SwiftUI

struct GridLayout {
    private var size: CGSize
    private var rowCount: Int = 0
    private var columnCount: Int = 0
    
    init(itemCount: Int, nearAspectRatio desiredAspectRatio: Double = 1, in size: CGSize) {
        self.size = size
        
        guard size.width != 0, size.height != 0, itemCount > 0 else { return }

        if itemCount <= 3 {
            rowCount = 1
        } else if itemCount > 3 && itemCount <= 6 {
            rowCount = 2
        } else if itemCount > 6 && itemCount <= 9 {
            rowCount = 2
        } else {
            rowCount = 4
        }
        columnCount = 3
    }
    
    var itemSize: CGSize {
        if rowCount == 0 || columnCount == 0 {
            return CGSize.zero
        } else {
            return CGSize(
                width: size.width / CGFloat(columnCount),
                height: size.height / CGFloat(rowCount)
            )
        }
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        if rowCount == 0 || columnCount == 0 {
            return CGPoint.zero
        } else {
            return CGPoint(
                x: (CGFloat(index % columnCount) + 0.5) * itemSize.width,
                y: (CGFloat(index / columnCount) + 0.5) * itemSize.height
            )
        }
    }
}

