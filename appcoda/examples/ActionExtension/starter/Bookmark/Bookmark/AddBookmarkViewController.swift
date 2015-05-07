//
//  AddBookmarkViewController.swift
//  Bookmark
//
//  Created by Joyce Echessa on 3/9/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import BookmarkKit

class AddBookmarkViewController: UIViewController {
    
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        if (urlTextField.text.isEmpty || titleTextField.text.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "Both field should be filled", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            let bookmark = Bookmark(url: NSURL(string:urlTextField.text)!, title: titleTextField.text)
            let bookmarkService = BookmarkService.sharedService
            bookmarkService.addBookmark(bookmark)
            bookmarkService.saveBookmarks()
            let alert = UIAlertController(title: "Saved", message: "Saved", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

}
