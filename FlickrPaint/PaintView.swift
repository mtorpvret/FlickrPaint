//
//  PaintView.swift
//  MonsterColoring
//
//  Created by Markus Torpvret on 2016-02-20.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class PaintView: UIImageView {
    private var _cImage = ColoringImage(size: CGSize(width: 100,height: 100))
    var context: PaintingContext?
    var scrollView: UIScrollView?
    var cancelled = false
    
    
    var paintImage: UIImage? {
        get {
            return image
        }
        set(paintImage) {
            if let existingPaintImage = paintImage {
                if let newImage = ColoringImage(image: existingPaintImage) {
                    _cImage = newImage
                    _cImage.makeBWImage()
                    updateImage()
                }
            }
        }
    }
    
    func updateImage() {
        image = _cImage.toUIImage()
        context?.currentImage = image
        
    }

    func outOfBounds(point: CGPoint, width: Int, height: Int) -> Bool {
        return point.x > CGFloat(width) || point.y > CGFloat(height)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancelled = false
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancelled = true
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if !cancelled {
            let imgSize = image!.size
            let viewBounds = self.bounds
            
            let xScale = viewBounds.width / imgSize.width
            let yScale = viewBounds.height / imgSize.height
            let imgScale = min(xScale, yScale)
            
            let xOffset = (viewBounds.width - imgSize.width * imgScale) / 2
            let yOffset = (viewBounds.height - imgSize.height * imgScale) / 2
            
            if touches.count > 1 { return }
            if let touch = touches.first {
                let pos = touch.locationInView(self)
                let scaledPos = CGPoint(x: (pos.x - xOffset) / imgScale, y: (pos.y - yOffset) / imgScale)
                if outOfBounds(scaledPos, width: _cImage.width, height: _cImage.height) { return }
            
                let colorPixel = context!.color
                _cImage.fillWithColor(colorPixel, atPoint: scaledPos)
                updateImage()
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        cancelled = true
        super.touchesCancelled(touches, withEvent: event)
    }
}