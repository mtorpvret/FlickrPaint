//
//  ColoringImage
//
//  Extended from RGBAImage from the University of Toronto iOS Swift course
//

import UIKit

public struct Pixel {
    public var value: UInt32
        
    public var red: UInt8 {
        get {
            return UInt8(value & 0xFF)
        }
        set {
            value = UInt32(newValue) | (value & 0xFFFFFF00)
        }
    }
    
    public var green: UInt8 {
        get {
            return UInt8((value >> 8) & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF)
        }
    }
    
    public var blue: UInt8 {
        get {
            return UInt8((value >> 16) & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF)
        }
    }
    
    public var alpha: UInt8 {
        get {
            return UInt8((value >> 24) & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF)
        }
    }
}


func ==(lhs: Pixel, rhs: Pixel) -> Bool {
    return lhs.red == rhs.red && lhs.green == rhs.green && lhs.blue == rhs.blue && lhs.alpha == rhs.alpha
}

// This is RGBAImage renamed to ColoringImage since it's been extended below
public struct ColoringImage {
    public var pixels: UnsafeMutableBufferPointer<Pixel>
    
    public var width: Int
    public var height: Int
    
    public init?(image: UIImage) {
        guard let cgImage = image.CGImage else { return nil }
        
        // Redraw image for correct pixel format
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        
        width = Int(image.size.width)
        height = Int(image.size.height)
        let bytesPerRow = width * 4
        
        let imageData = UnsafeMutablePointer<Pixel>.alloc(width * height)
        
        guard let imageContext = CGBitmapContextCreate(imageData, width, height, 8, bytesPerRow, colorSpace, bitmapInfo) else { return nil }
        CGContextDrawImage(imageContext, CGRect(origin: CGPointZero, size: image.size), cgImage)

        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }
    
    public func toUIImage() -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        
        let bytesPerRow = width * 4

        let imageContext = CGBitmapContextCreateWithData(pixels.baseAddress, width, height, 8, bytesPerRow, colorSpace, bitmapInfo, nil, nil)
        
        guard let cgImage = CGBitmapContextCreateImage(imageContext) else {return nil}
        let image = UIImage(CGImage: cgImage)
        
        return image
    }
}

// My extensions
extension ColoringImage {
    public init(size: CGSize) {
        width = Int(size.width)
        height = Int(size.height)
        
        let imageData = UnsafeMutablePointer<Pixel>.alloc(width * height)
        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        for i in 0..<pixels.count {
            var pixel = pixels[i]
            pixel.red = 255
            pixel.green = 255
            pixel.blue = 255
            pixel.alpha = 255
            pixels[i] = pixel
        }
    }
    
    func makeBWImage() {
        for i in 0..<pixels.count {
            var pixel = pixels[i]
            let pValue: UInt8 = shouldBeWhite(pixel) ? 255 : 0
            pixel.red = pValue
            pixel.green = pValue
            pixel.blue = pValue
            pixel.alpha = 255
            pixels[i] = pixel
        }
    }
    
    func shouldBeWhite(pixel: Pixel) -> Bool {
        // first make grayscale
        if pixel.alpha < 1 { return true }
        let gsPixel = 0.21 * Double(pixel.red) + 0.72 * Double(pixel.green) + 0.07 * Double(pixel.blue)
        return gsPixel > 200 ? true : false
        // TODO: Could use more sophisticated threshold depending on how dark image is
    }
    
    func fillWithColor(colorPixel: Pixel, atPoint origin: CGPoint) {
        let x = Int(origin.x)
        let y = Int(origin.y)
        let pointsToFill:[(Int, Int)] = [(x,y)]
        let originalColor = pixels[indexFor(x: x, y: y)]
        if originalColor == colorPixel { return } // already the right color
        fill(pointsToFill, fromColor: originalColor, toColor: colorPixel)
    }

    // Had to make it imperative because couldn't get tail recursion optimization to work :-(
    func fill(var pointsToFill: [(Int, Int)], fromColor: Pixel, toColor: Pixel) {
        var i = 0
        while pointsToFill.count > i {
            let (x, y) = pointsToFill[i]
            let p = indexFor(x: x, y: y)
            if pixels[p] == fromColor {
                pixels[p] = toColor
                if x > 0 { pointsToFill.append((x-1, y)) }
                if y > 0 { pointsToFill.append((x, y-1)) }
                if x < width-1 { pointsToFill.append((x+1, y)) }
                if y < height-1 { pointsToFill.append((x, y+1)) }
            }
            i += 1
        }
    }
    
    func indexFor(x x: Int, y: Int) -> Int {
        return x + width * y
    }
    
}
