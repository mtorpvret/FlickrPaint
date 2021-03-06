//
//  BrowseFeedViewController.swift
//  MonsterColoring
//
//  Created by Markus Torpvret on 2016-02-19.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//
// Displays black and white photos from the flickr stream with the coloringbook tag set,
// which should make them suitable to color.
//

import UIKit

class BrowseFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var urlSession: NSURLSession!
    var context: PaintingContext?
    
    @IBAction func imageSelected(sender: UIButton) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! ColoringTableCell
            useImageFromFlickr(currentCell.imageLink!)
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    var feed: Feed? {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        let tbc = tabBarController as! PaintingTabBarController
        context = tbc.context
        tableView.delegate = self
        tableView.dataSource = self
        updateFeed()
    }

    func updateFeed() {
        if let url = NSURL(string: "https://api.flickr.com/services/feeds/photos_public.gne/?tags=coloringbook,blackandwhite&format=json&nojsoncallback=1") {
            let request = NSURLRequest(URL: url)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                if error == nil && data != nil {
                    let feed = Feed(data: data!, sourceURL: url)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.feed = feed
                    })
                }
            }
            task.resume()
        }
    }
    
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.urlSession.invalidateAndCancel()
        self.urlSession = nil
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed?.items.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ColoringTableCell", forIndexPath: indexPath) as! ColoringTableCell
        
        let item = self.feed!.items[indexPath.row]
        cell.title.text = item.title
        cell.imageLink = item.imageURL
        
        let request = NSURLRequest(URL: item.previewURL)
        
        cell.dataTask = self.urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    cell.previewImage.image = image
                }
            })
            
        }
        
        cell.dataTask?.resume()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? ColoringTableCell {
            cell.dataTask?.cancel()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func useImageFromFlickr(url: NSURL) {
        let request = NSURLRequest(URL: url)
        let dataTask = self.urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if error == nil && data != nil {
                    self.context!.newImage = UIImage(data: data!)
                }
            })
            
        }
        dataTask.resume()
    }
    
}

