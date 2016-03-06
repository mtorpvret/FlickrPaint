//
//  PaintViewController.swift
//  MonsterColoring
//
//  Created by Markus Torpvret on 2016-02-19.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var paintView: PaintView!

    var context: PaintingContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        let tbc = tabBarController as! PaintingTabBarController
        context = tbc.context
        paintView.scrollView = scrollView
        let startImage = UIImage(named: "owlWithGlasses.png")
        paintView.paintImage = startImage
        paintView.context = context
        context!.currentImage = startImage
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let newImage = context!.newImage {
            paintView.paintImage = newImage
            context!.newImage = nil
        }
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return paintView
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

