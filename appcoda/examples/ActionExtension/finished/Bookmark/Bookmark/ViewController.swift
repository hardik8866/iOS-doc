//
//  ViewController.swift
//  Bookmark
//
//  Created by Joyce Echessa on 3/8/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView
    var url: NSURL!
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.addSubview(webView)
            
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        view.addConstraint(heightConstraint)
            
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
    }

}

