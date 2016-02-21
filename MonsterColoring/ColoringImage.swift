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
        let gsPixel = 0.21 * Double(pixel.red) + 0.72 * Double(pixel.green) + 0.07 * Double(pixel.blue)
        return gsPixel > 200 ? true : false
        // TODO: Could use more sophisticated threshold depending on how dark image is
    }
    
    func fillWithColor(colorPixel: Pixel, atPoint origin: CGPoint) {
        let x = Int(origin.x)
        let y = Int(origin.y)
        let originalColor = pixels[indexFor(x: x, y: y)]
        fill(x: x, y: y, fromColor: originalColor, toColor: colorPixel)
    }
 
    func fill(x x: Int, y: Int, fromColor: Pixel, toColor: Pixel) {
        if fromColor == toColor { return } // already the right color
        if pixels[indexFor(x: x, y: y)] == fromColor {
            pixels[indexFor(x: x, y: y)] = toColor
            if x > 0 { fill(x: x-1, y: y, fromColor: fromColor, toColor: toColor) }
            if y > 0 {fill(x: x, y: y-1, fromColor: fromColor, toColor: toColor) }
            if x < width-1 { fill(x: x+1, y: y, fromColor: fromColor, toColor: toColor) }
            if y < height-1 { fill(x: x, y: y+1, fromColor: fromColor, toColor: toColor) }
        }
    }
    
    func indexFor(x x: Int, y: Int) -> Int {
        return x + width * y
    }
    
}
