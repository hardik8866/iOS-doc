//
//  ActionRequestHandler.swift
//  Capitalize
//
//  Created by Joyce Echessa on 3/12/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        self.extensionContext = context
        
        for item: AnyObject in context.inputItems {
            
            let inputItem = item as NSExtensionItem
            
            for provider: AnyObject in inputItem.attachments! {
                
                let itemProvider = provider as NSItemProvider
                
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as NSString) {
                    
                    itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as NSString, options: nil, completionHandler: { [unowned self] (result: NSSecureCoding!, error: NSError!) -> Void in
                        
                        if let dictionary = result as? NSDictionary {
                            self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as [NSObject: AnyObject])
                        }
                        
                    });
                    
                }
            }
        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(javaScriptPreprocessingResults: [NSObject: AnyObject]) {
        let pageContent = javaScriptPreprocessingResults["content"] as NSString
        let capitalizedContent = pageContent.uppercaseString
        self.doneWithResults(["content": capitalizedContent])
    }
    
    func doneWithResults(resultsForJavaScriptFinalizeArg: [NSObject: AnyObject]?) {
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            
            var resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize]
            
            var resultsProvider = NSItemProvider(item: resultsDictionary, typeIdentifier: String(kUTTypePropertyList))
            
            var resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]
            
            self.extensionContext!.completeRequestReturningItems([resultsItem], completionHandler: nil)
        } else {
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        }
        
        self.extensionContext = nil
    }

}
