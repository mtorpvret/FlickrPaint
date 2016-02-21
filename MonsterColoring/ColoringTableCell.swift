//
//  ColoringTableCell.swift
//  MonsterColoring
//
//  Created by Markus Torpvret on 2016-02-21.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class ColoringTableCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var previewImage: UIImageView!

    weak var dataTask: NSURLSessionDataTask?
}
