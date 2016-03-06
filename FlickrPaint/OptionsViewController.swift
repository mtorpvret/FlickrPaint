//
//  OptionsViewController.swift
//  FlickrPaint
//
//  Created by Markus Torpvret on 2016-03-06.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    var context: PaintingContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbc = tabBarController as! PaintingTabBarController
        context = tbc.context        
    }
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        if let existingCurrentImage = context!.currentImage {
            let activityController = UIActivityViewController(activityItems: [existingCurrentImage], applicationActivities: nil)
            presentViewController(activityController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

}


