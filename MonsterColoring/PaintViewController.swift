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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        paintView.scrollView = scrollView
        paintView.paintImage = UIImage(named: "coloringtest.jpg")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tbc = tabBarController as! PaintingTabBarController
        paintView.context = tbc.context
        if let newImage = tbc.context.newImage {
            paintView.paintImage = newImage
            tbc.context.newImage = nil
        }
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return paintView
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

