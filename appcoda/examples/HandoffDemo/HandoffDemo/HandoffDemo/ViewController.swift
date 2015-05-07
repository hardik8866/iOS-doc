//
//  ViewController.swift
//  HandoffDemo
//
//  Created by Gabriel Theodoropoulos on 17/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditContactViewControllerDelegate {

    @IBOutlet weak var tblContacts: UITableView!
    
    var contactsArray: NSMutableArray!
    
    var indexOfContactToView: Int!
    
    var continuedActivity: NSUserActivity?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblContacts.delegate = self
        tblContacts.dataSource = self
        
        loadContacts()
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
    }
    
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        continuedActivity = activity

        if activity.activityType == "com.appcoda.handoffdemo.edit-contact" {
            self.performSegueWithIdentifier("idSegueEditContact", sender: self)
        }
        else{
            self.performSegueWithIdentifier("idSegueViewContact", sender: self)
        }
        
        super.restoreUserActivityState(activity)
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
    }
}
