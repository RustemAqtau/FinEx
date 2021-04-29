//
//  ChartColorTemplates.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

open class ChartColorTemplates: NSObject
{
    @objc open class func expensesBright () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 1.000, green: 0.007, blue: 0.320, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.301, blue: 0.357, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.267, blue: 0.624, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.412, blue: 0.624, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.500, blue: 0.624, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.670, blue: 0.624, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.801, blue: 0.624, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.907, blue: 0.624, alpha: 1.0)
            
        ]
    }
    
    @objc open class func expensesPastel () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 1.000, green: 0.528, blue: 0.536, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.626, blue: 0.628, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.757, blue: 0.751, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.904, blue: 0.802, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.715, blue: 0.500, alpha: 1.0),
            NSUIColor(red: 1.000, green: 0.800, blue: 0.430, alpha: 1.0),
            NSUIColor(red: 1.000, green: 1.000, blue: 0.474, alpha: 1.0),
            NSUIColor(red: 1.000, green: 1.000, blue: 0.624, alpha: 1.0)
            
        ]
    }
    
    @objc open class func incomePastel () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 0.000, green: 0.445, blue: 0.443, alpha: 1.0),
            NSUIColor(red: 0.000, green: 0.558, blue: 0.569, alpha: 1.0),
            NSUIColor(red: 0.000, green: 0.678, blue: 0.688, alpha: 1.0),
            NSUIColor(red: 0.000, green: 0.854, blue: 0.720, alpha: 1.0),
            NSUIColor(red: 0.000, green: 1.000, blue: 1.000, alpha: 1.0),
            NSUIColor(red: 0.000, green: 0.804, blue: 1.000, alpha: 1.0),
            NSUIColor(red: 0.000, green: 1.000, blue: 0.474, alpha: 1.0),
            NSUIColor(red: 0.000, green: 1.000, blue: 0.624, alpha: 1.0)
            
        ]
    }
    
    @objc open class func savingPastel () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 0.220, green: 0.690, blue: 0.549, alpha: 1.0),
            NSUIColor(red: 0.315, green: 0.753, blue: 0.655, alpha: 1.0),
            NSUIColor(red: 0.410, green: 0.852, blue: 0.688, alpha: 1.0),
            NSUIColor(red: 0.481, green: 0.963, blue: 0.829, alpha: 1.0),
            NSUIColor(red: 0.700, green: 1.000, blue: 1.000, alpha: 1.0),
            NSUIColor(red: 0.000, green: 0.804, blue: 1.000, alpha: 1.0),
            NSUIColor(red: 0.000, green: 1.000, blue: 0.474, alpha: 1.0),
            NSUIColor(red: 0.000, green: 1.000, blue: 0.624, alpha: 1.0)
            
        ]
    }
    
    @objc open class func incomeBarPastel () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 0.000, green: 0.445, blue: 0.443, alpha: 1.0)
        ]
    }
    
    @objc open class func expenseBarPastel () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 1.000, green: 0.528, blue: 0.536, alpha: 1.0)
        ]
    }
    
    @objc open class func savingBarPastel () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 0.220, green: 0.690, blue: 0.549, alpha: 1.0)
        ]
    }
    
    @objc open class func liberty () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 207/255.0, green: 248/255.0, blue: 246/255.0, alpha: 1.0),
            NSUIColor(red: 148/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1.0),
            NSUIColor(red: 136/255.0, green: 180/255.0, blue: 187/255.0, alpha: 1.0),
            NSUIColor(red: 118/255.0, green: 174/255.0, blue: 175/255.0, alpha: 1.0),
            NSUIColor(red: 42/255.0, green: 109/255.0, blue: 130/255.0, alpha: 1.0)
        ]
    }
    
    @objc open class func joyful () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 217/255.0, green: 80/255.0, blue: 138/255.0, alpha: 1.0),
            NSUIColor(red: 254/255.0, green: 149/255.0, blue: 7/255.0, alpha: 1.0),
            NSUIColor(red: 254/255.0, green: 247/255.0, blue: 120/255.0, alpha: 1.0),
            NSUIColor(red: 106/255.0, green: 167/255.0, blue: 134/255.0, alpha: 1.0),
            NSUIColor(red: 53/255.0, green: 194/255.0, blue: 209/255.0, alpha: 1.0)
        ]
    }
    
    @objc open class func pastel () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 64/255.0, green: 89/255.0, blue: 128/255.0, alpha: 1.0),
            NSUIColor(red: 149/255.0, green: 165/255.0, blue: 124/255.0, alpha: 1.0),
            NSUIColor(red: 217/255.0, green: 184/255.0, blue: 162/255.0, alpha: 1.0),
            NSUIColor(red: 191/255.0, green: 134/255.0, blue: 134/255.0, alpha: 1.0),
            NSUIColor(red: 179/255.0, green: 48/255.0, blue: 80/255.0, alpha: 1.0)
        ]
    }
    
    @objc open class func colorful () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 193/255.0, green: 37/255.0, blue: 82/255.0, alpha: 1.0),
            NSUIColor(red: 255/255.0, green: 102/255.0, blue: 0/255.0, alpha: 1.0),
            NSUIColor(red: 245/255.0, green: 199/255.0, blue: 0/255.0, alpha: 1.0),
            NSUIColor(red: 106/255.0, green: 150/255.0, blue: 31/255.0, alpha: 1.0),
            NSUIColor(red: 179/255.0, green: 100/255.0, blue: 53/255.0, alpha: 1.0)
        ]
    }
    
    @objc open class func vordiplom () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 192/255.0, green: 255/255.0, blue: 140/255.0, alpha: 1.0),
            NSUIColor(red: 255/255.0, green: 247/255.0, blue: 140/255.0, alpha: 1.0),
            NSUIColor(red: 255/255.0, green: 208/255.0, blue: 140/255.0, alpha: 1.0),
            NSUIColor(red: 140/255.0, green: 234/255.0, blue: 255/255.0, alpha: 1.0),
            NSUIColor(red: 255/255.0, green: 140/255.0, blue: 157/255.0, alpha: 1.0)
        ]
    }
    
    @objc open class func material () -> [NSUIColor]
    {
        return [
            NSUIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0),
            NSUIColor(red: 241/255.0, green: 196/255.0, blue: 15/255.0, alpha: 1.0),
            NSUIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0),
            NSUIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        ]
    }
    
    @objc open class func colorFromString(_ colorString: String) -> NSUIColor
    {
        let leftParenCharset: CharacterSet = CharacterSet(charactersIn: "( ")
        let commaCharset: CharacterSet = CharacterSet(charactersIn: ", ")

        let colorString = colorString.lowercased()
        
        if colorString.hasPrefix("#")
        {
            var argb: [UInt] = [255, 0, 0, 0]
            let colorString = colorString.unicodeScalars
            var length = colorString.count
            var index = colorString.startIndex
            let endIndex = colorString.endIndex
            
            index = colorString.index(after: index)
            length = length - 1
            
            if length == 3 || length == 6 || length == 8
            {
                var i = length == 8 ? 0 : 1
                while index < endIndex
                {
                    var c = colorString[index]
                    index = colorString.index(after: index)
                    
                    var val = (c.value >= 0x61 && c.value <= 0x66) ? (c.value - 0x61 + 10) : c.value - 0x30
                    argb[i] = UInt(val) * 16
                    if length == 3
                    {
                        argb[i] = argb[i] + UInt(val)
                    }
                    else
                    {
                        c = colorString[index]
                        index = colorString.index(after: index)
                        
                        val = (c.value >= 0x61 && c.value <= 0x66) ? (c.value - 0x61 + 10) : c.value - 0x30
                        argb[i] = argb[i] + UInt(val)
                    }
                    
                    i += 1
                }
            }
            
            return NSUIColor(red: CGFloat(argb[1]) / 255.0, green: CGFloat(argb[2]) / 255.0, blue: CGFloat(argb[3]) / 255.0, alpha: CGFloat(argb[0]) / 255.0)
        }
        else if colorString.hasPrefix("rgba")
        {
            var a: Float = 1.0
            var r: Int32 = 0
            var g: Int32 = 0
            var b: Int32 = 0
            let scanner: Scanner = Scanner(string: colorString)
            scanner.scanString("rgba", into: nil)
            scanner.scanCharacters(from: leftParenCharset, into: nil)
            scanner.scanInt32(&r)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&g)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&b)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanFloat(&a)
            return NSUIColor(
                red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: CGFloat(a)
            )
        }
        else if colorString.hasPrefix("argb")
        {
            var a: Float = 1.0
            var r: Int32 = 0
            var g: Int32 = 0
            var b: Int32 = 0
            let scanner: Scanner = Scanner(string: colorString)
            scanner.scanString("argb", into: nil)
            scanner.scanCharacters(from: leftParenCharset, into: nil)
            scanner.scanFloat(&a)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&r)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&g)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&b)
            return NSUIColor(
                red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: CGFloat(a)
            )
        }
        else if colorString.hasPrefix("rgb")
        {
            var r: Int32 = 0
            var g: Int32 = 0
            var b: Int32 = 0
            let scanner: Scanner = Scanner(string: colorString)
            scanner.scanString("rgb", into: nil)
            scanner.scanCharacters(from: leftParenCharset, into: nil)
            scanner.scanInt32(&r)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&g)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&b)
            return NSUIColor(
                red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: 1.0
            )
        }
        
        return NSUIColor.clear
    }
}
