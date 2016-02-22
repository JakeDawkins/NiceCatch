//
//  personalViewController.swift
//  NiceCatch
//
//  Created by Daniel Battle on 11/16/15.
//  Copyright © 2015 Daniel Battle. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import CoreData
import Parse
import Alamofire

class personalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var designTextField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumField: UITextField!
    
    @IBOutlet weak var designPicker: UIPickerView!
    
    //let designData = ["Faculty", "Staff", "Student", "Other"]
    var designData:Array<String> = []
    var jsonArray:NSMutableArray?
    
    
    
    //------------------------ UI METHODS ------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designPicker.dataSource = self
        designPicker.delegate = self
        designTextField.hidden = true
        
        designTextField.delegate = self
        nameField.delegate = self
        emailField.delegate = self
        phoneNumField.delegate = self
        
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        //------------------------ LOAD DESIGNATION NAMES FROM DB ------------------------
        Alamofire.request(.GET, "http://people.cs.clemson.edu/~jacksod/api/?controller=loader&action=getDefaultPersonKinds").responseJSON { response in
            if let JSON = response.result.value {
                self.jsonArray = JSON["data"] as? NSMutableArray
                if(self.jsonArray != nil){
                    for item in self.jsonArray! {
                        let string = item["personKind"]!
                        self.designData.append(string! as! String)
                    }
                }
                //print("BuildingNames array is \(self.campusBuildingNames)")
                self.designPicker.reloadAllComponents()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //------------------------ KEYBOARD METHODS ------------------------

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    var hasMoved = false
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        if !hasMoved && phoneNumField.isFirstResponder() {
            self.view.center.y = self.view.center.y - keyboardHeight
            hasMoved = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        if hasMoved && phoneNumField.isFirstResponder() {
            self.view.center.y = self.view.center.y + keyboardHeight
            hasMoved = false
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return designData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return designData[row]
    }
    
    var designSelection: String = ""
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if designData[row] == "Other" {
            designTextField.hidden = false;
        } else {
            designTextField.hidden = true;
        }
        designSelection = designData[row]
    }
    
    func addPersonalInfo() {
        if designSelection == "Other" {
            finalReportData.designation = designTextField.text!
        } else if designSelection == "" {
            finalReportData.designation = "Faculty"
        } else {
            finalReportData.designation = designSelection
        }
        finalReportData.name = nameField.text!
        finalReportData.email = emailField.text!
        finalReportData.phoneNum = phoneNumField.text!
    }
    
    var isContact = false

    @IBAction func submitClicked(sender: AnyObject) {
        self.addPersonalInfo()
        
        let alert = UIAlertController(title: "Alert", message: "Do you want someone from Research Safety to contact you?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            switch action.style{
                case .Default:
                    self.isContact = true
                    self.addToDatabase()
                    self.presentThankYou()
                case .Cancel:
                    print("cancel")
                case .Destructive:
                    print("destructive")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { action in
            switch action.style{
                case .Default:
                    self.isContact = false
                    self.addToDatabase()
                    self.presentThankYou()
                case .Cancel:
                    print("cancel")
                case .Destructive:
                    print("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func sendEmail() {
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func presentThankYou() {
        let alert = UIAlertController(title: "Thank You!", message: "Thank you for submitting a Nice Catch! report. The Research Safety office will look at the report, and get back to you if you requested them to.\n\nAfter clicking OK, please click Send on the email that pops up. Then you may quit the app.", preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            switch action.style{
            case .Default:
                self.sendEmail()
            case .Cancel:
                print("cancel")
            case .Destructive:
                print("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["dbattle@g.clemson.edu"])
        mailComposerVC.setSubject("Nice Catch Report")
        
        var emailBody = "Kind of report: " + finalReportData.reportKind + "\nKind of involvement: " + finalReportData.involveKind + "\nDescription of incident: " + finalReportData.incidentDesc + "\n\nDepartment: " + finalReportData.departmentName + "\nBuilding: " + finalReportData.buildingName + "\nRoom Number: " + finalReportData.roomNum + "\nDate of Incident: " + finalReportData.time + "\n\nDesignation: " + finalReportData.designation + "\nName: " + finalReportData.name + "\nEmail: " + finalReportData.email + "\nPhone Number: " + finalReportData.phoneNum
        
        if isContact {
            emailBody += "\n\nContact: Yes"
        } else {
            emailBody += "\n\nContact: No"
        }
        
        //print(emailBody)
        
        mailComposerVC.setMessageBody(emailBody, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addToDatabase() {
        //var personAdded = false
        let newPerson = PFObject(className:"Person")
        /*if finalReportData.name == "" && finalReportData.email == "" && finalReportData.phoneNum == "" {
            // Don't add a person
        } else {*/
        
            //personAdded = true
        newPerson["name"] = finalReportData.name
        newPerson["email"] = finalReportData.email
        newPerson["phoneNum"] = finalReportData.phoneNum
        
        /*if finalReportData.designation != "Faculy" && finalReportData.designation != "Staff" && finalReportData.designation != "Student" {
            let newDesignation = PFObject(className:"Designation")
            newDesignation["designation"] = finalReportData.designation
            newPerson["designationID"] = newDesignation
        } else {
            let query = PFQuery(className:"Designation")
            query.whereKey("designation", equalTo:finalReportData.designation)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            newPerson["designationID"] = object
                            break
                        }
                    }
                } else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }*/
        newPerson["designation"] = finalReportData.designation
        
        /*newPerson.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Person created")
            } else {
                print("Person not created")
            }
        }*/
        newPerson.saveEventually()
        
        let newLocation = PFObject(className:"Location")
        newLocation["date"] = finalReportData.time
        newLocation["roomNum"] = finalReportData.roomNum
        /*let query2 = PFQuery(className:"Department")
        query2.whereKey("departName", equalTo:finalReportData.departmentName)
        query2.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        newLocation["departID"] = object
                        break
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }*/
        newLocation["department"] = finalReportData.departmentName
        
        //print("Here is the buildingName: ")
        //print(finalReportData.buildingName)
        /*let query3 = PFQuery(className:"Building")
        query3.whereKey("buildingName", equalTo:finalReportData.buildingName)
        query3.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            print("here building loop 11")
            if error == nil {
                print("Here before if")
                if let objects = objects {
                    print("in if statement building")
                    for object in objects {
                        print("here building loop")
                        newLocation["buildingID"] = object
                        break
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }*/
        newLocation["building"] = finalReportData.buildingName
        
        /*newLocation.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Location created")
            } else {
                print("Location not created")
            }
        }*/
        newLocation.saveEventually()

        let newReport = PFObject(className:"Report")
        newReport["desc"] = finalReportData.incidentDesc
        newReport["locationID"] = newLocation
        //if personAdded {
        newReport["personID"] = newPerson
        //}
        
        /*if finalReportData.reportKind != "Close Call" && finalReportData.reportKind != "Lesson Learned" && finalReportData.reportKind != "Safety Issue" {
            let newReportKind = PFObject(className:"ReportKind")
            newReportKind["desc"] = finalReportData.reportKind
            newReport["reportKindID"] = newReportKind
        } else {
            print("here report query")
            let query = PFQuery(className:"ReportKind")
            query.whereKey("desc", equalTo:finalReportData.reportKind)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            print("here")
                            newReport["reportKindID"] = object
                            break
                        }
                    }
                } else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }*/
        newReport["reportKind"] = finalReportData.reportKind
        
        /*print(finalReportData.involveKind)
        if finalReportData.involveKind != "Work Practice/Procedure" && finalReportData.involveKind != "Chemical" && finalReportData.involveKind != "Equipment" && finalReportData.involveKind != "Work Space Condition" {
            let newInvolveKind = PFObject(className:"InvolveKind")
            newInvolveKind["desc"] = finalReportData.reportKind
            newReport["involveKindID"] = newInvolveKind
        } else {
            print("here involve query")
            let query = PFQuery(className:"InvolveKind")
            query.whereKey("desc", equalTo:finalReportData.involveKind)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            print("here")
                            newReport["involveKindID"] = object
                            break
                        }
                    }
                } else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }*/
        newReport["involveKind"] = finalReportData.involveKind
        
        /*newReport.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Report created")
            } else {
                print("Report not created")
            }
        }*/
        /*if let imageData = UIImageJPEGRepresentation(finalReportData.image, 1.0) {
            if let imageFile: PFFile = PFFile(data: imageData)! {
                print("here")
                newReport["image"] = imageFile
            }
        } else {
            print("Got here")
        }*/
        if let imageData = UIImageJPEGRepresentation(finalReportData.image, 0.5) {
            if let imageFile: PFFile = PFFile(data: imageData)! {
                let newImage = PFObject(className:"Image")
                newImage["image"] = imageFile
                newImage.saveEventually()
                newReport["imageID"] = newImage
            }
        }
        
        //newReport.saveEventually()
        newReport.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                //print("Report created")
            } else {
                //print("Report not created")
            }
        }
        
        // check to make sure image is not null
        /*let imageData = UIImageJPEGRepresentation(finalReportData.image, 1.0)
        let imageFile: PFFile = PFFile(data: imageData!)!
        
        let newImage = PFObject(className:"Image")
        newImage["image"] = imageFile
        newImage.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Image created")
            } else {
                print("Image not created")
            }
        }*/
    }

}