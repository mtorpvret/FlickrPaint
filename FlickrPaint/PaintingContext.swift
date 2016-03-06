//
//  PaintingContext.swift
//  MonsterColoring
//
//  Created by Markus Torpvret on 2016-02-21.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class PaintingContext: NSObject {
    var color = Pixel(value: 0)
    var newImage: UIImage?
    var currentImage: UIImage?
}
