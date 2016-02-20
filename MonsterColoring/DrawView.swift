//
//  DrawView.swift
//  MonsterDraw
//
//  Created by Markus Torpvret on 2016-02-20.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class DrawView: UIImageView {
    private var _rgbaImage: RGBAImage?
    
    var rgbaImage: RGBAImage? {
        get {
            if _rgbaImage == nil {
                guard let existingImage = image else { return nil }
                _rgbaImage = RGBAImage(image: existingImage)
            }
            
            return _rgbaImage
        }
        set(rgbaImage) {
            if let _rgbaImage = rgbaImage {
                makeBWImage(_rgbaImage)
                image = _rgbaImage.toUIImage()
            }
        }
    }
   
    func makeBWImage(var rgbaImage: RGBAImage) {
        let pixels = rgbaImage.pixels
        for i in 0..<pixels.count {
            var pixel = pixels[i]
            let pValue: UInt8 = shouldBeWhite(pixel) ? 255 : 0
            pixel.red = pValue
            pixel.green = pValue
            pixel.blue = pValue
            pixel.alpha = 255
            pixels[i] = pixel
        }
        rgbaImage.pixels = pixels
    }
    
    func shouldBeWhite(pixel: Pixel) -> Bool {
        // first make grayscale
        let gsPixel = 0.21 * Double(pixel.red) + 0.72 * Double(pixel.green) + 0.07 * Double(pixel.blue)
        return gsPixel > 200 ? true : false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if touches.count > 1 { return }
        if let touch = touches.first {
            let pos = touch.locationInView(self)
            let colorPixel = Pixel(value: 0xCCCCCC)
            fillWithColor(colorPixel, atPoint: pos)
        }
        
    }
    
    func fillWithColor(colorPixel: Pixel, atPoint origin: CGPoint) {
   //     let originalColor = pixelAtPoint(origin)
        
    }
    
//    func pixelAtPoint(point: CGPoint) -> Pixel {
       //return (rgbaImage?.pixels[rgbaImage!.width * Int(point.y) + Int(point.x)])!
 //   }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
    }
}