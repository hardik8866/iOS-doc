//
//  ViewController.swift
//  HandoffDemo
//
//  Created by Gabriel Theodoropoulos on 17/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditContactViewControllerDelegate, NSUserActivityDelegate, NSStreamDelegate {

    @IBOutlet weak var tblContacts: UITableView!
    
    var contactsArray: NSMutableArray!
    
    var indexOfContactToView: Int!
    
    var continuedActivity: NSUserActivity?
    
    
    var outputStream: NSOutputStream!
    
    var dataToStream: NSData!
    
    var byteIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblContacts.delegate = self
        tblContacts.dataSource = self
        
        loadContacts()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleReceivedContactsDataWithNotification:", name: "receivedContactsDataNotification", object: nil)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        createUserActivity()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idSegueEditContact"{
            var editContactViewController = segue.destinationViewController as EditContactViewController
            
            editContactViewController.delegate = self
            
            if let activity = continuedActivity {
                editContactViewController.restoreUserActivityState(activity)
            }
        }
        
        
        if segue.identifier == "idSegueViewContact"{
            var viewContactViewController = segue.destinationViewController as ViewContactViewController
            
            if let activity = continuedActivity {
                viewContactViewController.restoreUserActivityState(activity)
            }
            else{
                viewContactViewController.contact = contactsArray.objectAtIndex(indexOfContactToView) as Contact
            }
        }
    }
    
    
    @IBAction func unwindToContactsListViewController(unwindSegue: UIStoryboardSegue){
        
    }
    
    
    // MARK: Method implementation
    
    func loadContacts(){
        let contact = Contact()
        contactsArray = contact.loadContacts()
    }

    
    func deleteContactAtIndex(index: Int){
        contactsArray.removeObjectAtIndex(index)
        Contact.updateSavedContacts(contactsArray)
        tblContacts.reloadData()
        
        userActivity?.needsSave = true
    }
    
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        continuedActivity = activity

        if activity.activityType == "com.appcoda.handoffdemo.list-contacts"{
            let totalNewContacts = activity.userInfo!["totalContacts"] as Int
            println(totalNewContacts)
        }
        else if activity.activityType == "com.appcoda.handoffdemo.edit-contact" {
            self.performSegueWithIdentifier("idSegueEditContact", sender: self)
        }
        else{
            self.performSegueWithIdentifier("idSegueViewContact", sender: self)
        }
        
        super.restoreUserActivityState(activity)
    }
    
    
    func createUserActivity() {
        userActivity = NSUserActivity(activityType: "com.appcoda.handoffdemo.list-contacts")
        userActivity?.title = "List Contacts"
        userActivity?.supportsContinuationStreams = true
        userActivity?.delegate = self
        userActivity?.becomeCurrent()
    }
    
    
    override func updateUserActivityState(activity: NSUserActivity) {
        var contactsInfoDictionary: [String: Int] = ["totalContacts": contactsArray.count]
        
        userActivity?.addUserInfoEntriesFromDictionary(contactsInfoDictionary)
        
        super.updateUserActivityState(activity)
    }
    
    
    
    func handleReceivedContactsDataWithNotification(notification: NSNotification) {
        let contactsData = notification.object as NSData
        
        contactsArray.removeAllObjects()
        
        contactsArray = NSKeyedUnarchiver.unarchiveObjectWithData(contactsData) as NSMutableArray
        
        Contact.updateSavedContacts(contactsArray)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tblContacts.reloadData()
        })
    }
    
    
    // MARK: UITableView method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("idCellContact") as UITableViewCell
        
        let contact = contactsArray.objectAtIndex(indexPath.row) as Contact
        cell.textLabel.text = contact.firstname! + " " + contact.lastname!
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexOfContactToView = indexPath.row
        
        self.performSegueWithIdentifier("idSegueViewContact", sender: self)
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            deleteContactAtIndex(indexPath.row)
        }
    }
    
    
    // MARK: EditContactViewControllerDelegate method implementation
    
    func contactWasSaved(contact: Contact) {
        contactsArray.addObject(contact)
        
        self.tblContacts.reloadData()
        
        userActivity?.needsSave = true
    }
    
    
    // MARK: NSUserActivityDelegate method implementation
    
    func userActivity(userActivity: NSUserActivity, didReceiveInputStream inputStream: NSInputStream, outputStream: NSOutputStream) {
        if let allContacts = contactsArray {
            byteIndex = 0
            
            dataToStream = NSKeyedArchiver.archivedDataWithRootObject(allContacts)
            
            self.outputStream = outputStream
            self.outputStream.delegate = self
            self.outputStream.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            self.outputStream.open()
        }
    }
    
    
    // MARK: NSStreamDelegate method implementation
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if aStream == self.outputStream{
            if eventCode == NSStreamEvent.HasSpaceAvailable{
                var readBytes = dataToStream.bytes
                readBytes += byteIndex
                
                var dataLength = dataToStream.length
                
                var len: Int!
                if dataLength - byteIndex >= 1024{
                    len = 1024
                }
                else{
                    len = dataLength - byteIndex
                }
                
                var buffer = Array<UInt8>(count: len, repeatedValue: 0)
                
                memcpy(UnsafeMutablePointer(buffer), readBytes, UInt(len))
                
                len = outputStream.write(buffer, maxLength: len)
                
                byteIndex = byteIndex + len
            }
            
            
            if eventCode == NSStreamEvent.EndEncountered{
                outputStream.close()
                outputStream.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                outputStream = nil
            }
        }    
    }
    
}
