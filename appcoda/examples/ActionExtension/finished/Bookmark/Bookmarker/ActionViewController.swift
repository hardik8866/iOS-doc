//
//  ActionViewController.swift
//  Bookmarker
//
//  Created by Joyce Echessa on 3/9/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import MobileCoreServices
import BookmarkKit

class ActionViewController: UIViewController {

    @IBOutlet weak var bookmarkTitle: UITextField!
    
    var bookmarkURL: NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let extensionItem = extensionContext?.inputItems.first as NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as NSItemProvider
        
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItemForTypeIdentifier(propertyList, options: nil, completionHandler: { (item, error) -> Void in
                let dictionary = item as NSDictionary
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as NSDictionary
                    let urlString = results["currentUrl"] as? String
                    self.bookmarkURL = NSURL(string: urlString!)
                }
            })
        } else {
            println("error")
        }
    }

    @IBAction func done() {
        var statusMessage: NSString
        
        if (bookmarkTitle.text.isEmpty) {
            statusMessage = "Cannot save bookmark without a title"
        } else {
            let bookmark = Bookmark(url: bookmarkURL, title: bookmarkTitle.text)
            let bookmarkService = BookmarkService.sharedService
            bookmarkService.addBookmark(bookmark)
            bookmarkService.saveBookmarks()
            statusMessage = "Saved successfully"
        }
        
        let extensionItem = NSExtensionItem()
        let statusDictionary = [ NSExtensionJavaScriptFinalizeArgumentKey : [ "statusMessage" : statusMessage ]]
        extensionItem.attachments = [ NSItemProvider(item: statusDictionary, typeIdentifier: kUTTypePropertyList as NSString)]
        
        self.extensionContext!.completeRequestReturningItems([extensionItem], completionHandler: nil)
    }

}
