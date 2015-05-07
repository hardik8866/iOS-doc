//
//  TableViewController.swift
//  Bookmark
//
//  Created by Joyce Echessa on 3/8/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import BookmarkKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookmarkService.sharedService.bookmarks.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bookmark = BookmarkService.sharedService.bookmarks[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = bookmark.title
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "openURL") {
            let indexPath: NSIndexPath = tableView.indexPathForSelectedRow()!
            let bookmark = BookmarkService.sharedService.bookmarks[indexPath.row]
            
            let destViewController = segue.destinationViewController as ViewController
            destViewController.url = bookmark.url
            
        }
        
    }

}