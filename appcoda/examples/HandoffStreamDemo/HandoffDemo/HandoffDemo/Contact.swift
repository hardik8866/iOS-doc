//
//  Contact.swift
//  HandoffDemo
//
//  Created by Gabriel Theodoropoulos on 17/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit
import Foundation


class Contact: NSObject, NSCoding {
    
    var firstname: NSString?
    
    var lastname: NSString?
    
    var phoneNumber: NSString?
    
    var email: NSString?
    
    let documentsDirectory: NSString?
    
    
    override init() {
        let pathsArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        documentsDirectory = pathsArray[0] as String
    }
    
    
    func loadContacts() -> NSMutableArray {
        let contactsFilePath = documentsDirectory?.stringByAppendingPathComponent("contacts")
        
        var allContacts = NSMutableArray()
        
        if NSFileManager.defaultManager().fileExistsAtPath(contactsFilePath!) {
            let savedContactsArray = NSMutableArray(contentsOfFile: contactsFilePath!)

            for var i=0; i<savedContactsArray?.count; ++i{
                let tempContact = Contact()
                tempContact.getContactDataFromDictionary(savedContactsArray?.objectAtIndex(i) as Dictionary<NSObject, AnyObject>)
                allContacts.addObject(tempContact)
            }
        }
        
        return allContacts
    }
    
    
    func saveContact() {
        let contactsFilePath = documentsDirectory?.stringByAppendingPathComponent("contacts")

        var allContacts = loadContacts()
        
        allContacts.addObject(self)
        
        var allContactsConverted = NSMutableArray()
        
        for var i=0; i<allContacts.count; ++i{
            allContactsConverted.addObject(allContacts.objectAtIndex(i).getDictionaryFromContactData())
        }
        
        allContactsConverted.writeToFile(contactsFilePath!, atomically: false)
    }
    
    
    class func updateSavedContacts(contacts: NSMutableArray) {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        let contactsFilePath = documentsDirectory.stringByAppendingPathComponent("contacts")
        
        var contactsConverted = NSMutableArray()
        
        for var i=0; i<contacts.count; ++i{
            contactsConverted.addObject(contacts.objectAtIndex(i).getDictionaryFromContactData())
        }
        
        contactsConverted.writeToFile(contactsFilePath, atomically: true)
    }
    
    
    func getDictionaryFromContactData() -> Dictionary<String, String> {
        var dictionary: [String: String] = ["firstname": firstname!, "lastname": lastname!, "phonenumber": phoneNumber!, "email": email!]
        
        return dictionary
    }
    
    
    func getContactDataFromDictionary(dictionary: Dictionary<NSObject, AnyObject>) {
        firstname = dictionary["firstname"] as? String
        lastname = dictionary["lastname"] as? String
        phoneNumber = dictionary["phonenumber"] as? String
        email = dictionary["email"] as? String
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(firstname, forKey: "firstname")
        aCoder.encodeObject(lastname, forKey: "lastname")
        aCoder.encodeObject(phoneNumber, forKey: "phoneNumber")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(documentsDirectory, forKey: "docdir")
    }
    
    
    required init(coder aDecoder: NSCoder) {
        firstname = aDecoder.decodeObjectForKey("firstname") as? NSString
        lastname = aDecoder.decodeObjectForKey("lastname") as? NSString
        phoneNumber = aDecoder.decodeObjectForKey("phoneNumber") as? NSString
        email = aDecoder.decodeObjectForKey("email") as? NSString
        documentsDirectory = aDecoder.decodeObjectForKey("docdir") as? NSString
    }
    
    
}
