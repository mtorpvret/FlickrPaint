//
//  DrawView.swift
//  MonsterDraw
//
//  Created by Markus Torpvret on 2016-02-20.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class DrawView: UIImageView {
    private var _cImage = ColoringImage(size: CGSize(width: 100,height: 100))
    
    var drawImage: UIImage? {
        get {
            return image
        }
        set(drawImage) {
            if let existingDrawImage = drawImage {
                if let newImage = ColoringImage(image: existingDrawImage) {
                    _cImage = newImage
                    _cImage.makeBWImage()
                    updateImage()
                }
            }
        }
    }
    
    func updateImage() {
        image = _cImage.toUIImage()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("View bounds: \(self.bounds)")
        print("Imgage size: \(_cImage.width)x\(_cImage.height)")
        super.touchesBegan(touches, withEvent: event)
        if touches.count > 1 { return }
        if let touch = touches.first {
            let pos = touch.locationInView(self)
            print("Point: \(pos)")
            if outOfBounds(pos, width: _cImage.width, height: _cImage.height) { return }
            let colorPixel = Pixel(value: 0xCCCCCC)
            _cImage.fillWithColor(colorPixel, atPoint: pos)
            updateImage()
        }
        
    }

    func outOfBounds(point: CGPoint, width: Int, height: Int) -> Bool {
        return point.x > CGFloat(width) || point.y > CGFloat(height)
    }
    
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