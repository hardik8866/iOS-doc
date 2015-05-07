//
//  ShareViewController.swift
//  ImgurUpload
//
//  Created by Joyce Echessa on 3/31/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import Social
import ImgurKit
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let content = extensionContext!.inputItems[0] as NSExtensionItem
        let contentType = kUTTypeImage as String
        
        for attachment in content.attachments as [NSItemProvider] {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                    
                attachment.loadItemForTypeIdentifier(contentType, options: nil) { data, error in
                    if error == nil {
                        let url = data as NSURL
                        if let imageData = NSData(contentsOfURL: url) {
                            self.selectedImage = UIImage(data: imageData)
                        }
                    } else {
                        
                        let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .Alert)
                        
                        let action = UIAlertAction(title: "Error", style: .Cancel) { _ in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                        alert.addAction(action)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    override func isContentValid() -> Bool {
        if let img = selectedImage{
            if !contentText.isEmpty {
                return true
            }
        }
        
        return false
    }
    
    override func didSelectPost() {
        let defaultSession = UploadImageService.sharedService.session
        let defaultSessionConfig = defaultSession.configuration
        let defaultHeaders = defaultSessionConfig.HTTPAdditionalHeaders
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.appcoda.ImgurShare.bkgrdsession")
        config.sharedContainerIdentifier = "group.com.appcoda.ImgurShare"
        config.HTTPAdditionalHeaders = defaultHeaders
        
        let session = NSURLSession(configuration: config, delegate: UploadImageService.sharedService, delegateQueue: NSOperationQueue.mainQueue())
        
        let completion: (TempImage?, NSError?, NSURL?) -> () = { image, error, tempURL in
            if error == nil {
                if let imageURL = image?.link {
                    let image = Image(imgTitle: self.contentText, imgImage: self.selectedImage!)
                    image.url = imageURL
                    let imageService = ImageService.sharedService
                    imageService.addImage(image)
                    imageService.saveImages()
                }
                if let container = tempURL {
                    var delError: NSError?
                    if NSFileManager.defaultManager().isDeletableFileAtPath(container.path!) {
                        let success = NSFileManager.defaultManager().removeItemAtPath(container.path!, error: &delError)
                        if(!success) {
                            println("Error removing file at path: \(error?.description)")
                        }
                    }
                }
            } else {
                println("Error uploading image: \(error!)")
                if let container = tempURL {
                    var delError: NSError?
                    if NSFileManager.defaultManager().isDeletableFileAtPath(container.path!) {
                        let success = NSFileManager.defaultManager().removeItemAtPath(container.path!, error: &delError)
                        if(!success) {
                            println("Error removing file at path: \(error?.description)")
                        }
                    }
                }
            }
        }
        
        let title = contentText
        UploadImageService.sharedService.uploadImage(selectedImage!, title: title, session: session, completion:completion)
        
        self.extensionContext?.completeRequestReturningItems([], nil)
    }
    
    override func configurationItems() -> [AnyObject]! {
        
        return []
    }

}
