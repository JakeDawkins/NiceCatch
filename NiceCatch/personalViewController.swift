//
//  personalViewController.swift
//  NiceCatch
//
//  Created by Daniel Battle on 11/16/15.
//  Copyright © 2015 Daniel Battle. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire

class personalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var designTextField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumField: UITextField!
    
    @IBOutlet weak var designPicker: UIPickerView!
    
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
    
    
    //------------------------ ACTION HANDLERS ------------------------
    var isContact = false //whether or not to be contacted by research safety

    //This submits the form and calls method to save to DB
    @IBAction func submitClicked(sender: AnyObject) {
        self.addPersonalInfo()
        
//        let alert = UIAlertController(title: "Alert", message: "Do you want someone from Research Safety to contact you?", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
//            switch action.style{
//                case .Default:
//                    self.isContact = true
//                    self.addToDatabase()
//                    self.presentThankYou()
//                case .Cancel:
//                    print("cancel")
//                case .Destructive:
//                    print("destructive")
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { action in
//            switch action.style{
//                case .Default:
//                    self.isContact = false
//                    self.addToDatabase()
//                    self.presentThankYou()
//                case .Cancel:
//                    print("cancel")
//                case .Destructive:
//                    print("destructive")
//            }
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)

        self.addToDatabase()
        self.presentThankYou()
    }
    
    
    //popup window that appears after submission
    func presentThankYou() {
        let alert = UIAlertController(title: "Thank You!", message: "Thank you for submitting a Nice Catch! report. The Research Safety office will review your report.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    
    //------------------------ HELPER METHODS ------------------------
    
    func addToDatabase() {
        let params = [
            "description":finalReportData.incidentDesc,
            "involvementKind":finalReportData.involveKind,
            "reportKind":finalReportData.reportKind,
            "buildingName":finalReportData.buildingName,
            "room":finalReportData.roomNum,
            "personID":"1", //CHANGE
            "department":finalReportData.departmentName,
            "dateTime":"2016-02-25 11:13:01",
            "statusID":"1", //FOR NEW REPORTS
            "actionTaken":""
        ]
        
        Alamofire.request(.POST, "http://people.cs.clemson.edu/~jacksod/api/?controller=report", parameters: params).responseJSON { response in
            if let JSON = response.result.value {
                print(JSON)
            }
        }
    }
}