//
//  DrawView.swift
//  MonsterDraw
//
//  Created by Markus Torpvret on 2016-02-20.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class DrawView: UIImageView {
    
    var rgbaImage: RGBAImage? {
        get {
            guard let existingImage = image else { return nil }
            return RGBAImage(image: existingImage)
        }
        set(rgbaImage) {
            image = rgbaImage?.toUIImage()
        }
    }
   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if touches.count > 1 { return }
        if let touch = touches.first {
            let pos = touch.locationInView(self)
        }
        
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