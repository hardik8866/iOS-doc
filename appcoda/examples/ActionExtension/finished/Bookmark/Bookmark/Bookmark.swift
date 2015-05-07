//
//  Bookmark.swift
//  Bookmark
//
//  Created by Joyce Echessa on 3/8/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

public class Bookmark: NSObject, NSCoding {
    
    public let url: NSURL?
    public let title: String
    
    public init(url: NSURL, title: String) {
        self.url = url
        self.title = title
        super.init()
    }
    
    public required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("title") as String
        url = aDecoder.decodeObjectForKey("url") as? NSURL
    }
    
    public func encodeWithCoder(aCoder: NSCoder)  {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(url, forKey: "url")
    }
   
}

