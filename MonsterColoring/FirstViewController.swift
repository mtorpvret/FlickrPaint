//
//  FirstViewController.swift
//  MonsterDraw
//
//  Created by Markus Torpvret on 2016-02-19.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var drawView: DrawView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        drawView.drawImage = UIImage(named: "coloringtest.jpg")
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return drawView
    }

}

