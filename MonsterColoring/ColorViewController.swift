//
//  ColorViewController.swift
//  MonsterColoring
//
//  Created by Markus Torpvret on 2016-02-21.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, HSBColorPickerDelegate {
    
    @IBOutlet var colorPicker: HSBColorPicker!
    
    var pixelColor = Pixel(value: 0)
    var context: PaintingContext?
    
    @IBOutlet var selectedColor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedColor.backgroundColor = UIColor.blackColor()
        colorPicker.delegate = self
        let tbc = tabBarController as! PaintingTabBarController
        context = tbc.context

    }
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        var r = CGFloat()
        var g = CGFloat()
        var b = CGFloat()
        var a = CGFloat()
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
             let red = UInt32(r*255)
            let green = UInt32(g*255)
            let blue = UInt32(b*255)
            let alpha = UInt32(a*255)
            pixelColor = Pixel(value: alpha << 24 + blue << 16 + green << 8 + red)
            context!.color = pixelColor
            selectedColor.backgroundColor = color
        }
    }
}


