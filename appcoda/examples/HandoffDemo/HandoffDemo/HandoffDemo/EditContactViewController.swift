//
//  EditContactViewController.swift
//  HandoffDemo
//
//  Created by Gabriel Theodoropoulos on 17/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit


protocol EditContactViewControllerDelegate{
    func contactWasSaved(contact: Contact)
}


class EditContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    var delegate: EditContactViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtPhoneNumber.delegate = self
        txtEmail.delegate = self
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userInfo = userActivity?.userInfo {
            var contact = Contact()
            contact.getContactDataFromDictionary(userInfo)

            txtFirstName.text = contact.firstname
            txtLastName.text = contact.lastname
            txtPhoneNumber.text = contact.phoneNumber
            txtEmail.text = contact.email
        }
        
        createUserActivity()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "idUnwindSegueEditContact"{
            self.userActivity?.invalidate()
        }
    }
    

    
    // MARK: IBAction method implementation
    
    @IBAction func saveContact(sender: AnyObject) {
        var editedContact = Contact()
        
        editedContact.firstname = txtFirstName.text
        editedContact.lastname = txtLastName.text
        editedContact.phoneNumber = txtPhoneNumber.text
        editedContact.email = txtEmail.text
        
        editedContact.saveContact()
        
        self.delegate?.contactWasSaved(editedContact)
        
        self.performSegueWithIdentifier("idUnwindSegueEditContact", sender: self)
    }
    
    
    // MARK: Method implementation
    
    func createUserActivity() {
        userActivity = NSUserActivity(activityType: "com.appcoda.handoffdemo.edit-contact")
        
        userActivity?.title = "Edit Contact"
        
        userActivity?.becomeCurrent()
    }
    
    
    override func updateUserActivityState(activity: NSUserActivity) {
        let contact = Contact()
        
        contact.firstname = txtFirstName.text
        contact.lastname = txtLastName.text
        contact.phoneNumber = txtPhoneNumber.text
        contact.email = txtEmail.text
        
        activity.addUserInfoEntriesFromDictionary(contact.getDictionaryFromContactData())

        super.updateUserActivityState(activity)
    }
    
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        userActivity = activity
        
        super.restoreUserActivityState(activity)
    }
    
    
    // MARK: UITextFieldDelegate method implementation
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        userActivity?.needsSave = true
        
        // Alternatively:
        //updateUserActivityState(self.userActivity!)
        
        return true
    }
}
