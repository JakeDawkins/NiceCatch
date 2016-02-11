//
//  reportController.swift
//  NiceCatch
//
//  Created by Daniel Battle on 11/11/15.
//  Copyright © 2015 Daniel Battle. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class reportController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var reportPicker: UIPickerView!
    let reportData = ["Close Call", "Lesson Learned", "Safety Issue", "Other"]
    
    @IBOutlet weak var involvePicker: UIPickerView!
    let involveData = ["Work Practice/Procedure", "Chemical", "Equipment", "Work Space Condition", "Other"]
    
    @IBOutlet weak var reportTextBox: UITextField!
    @IBOutlet weak var involveTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reportPicker.dataSource = self
        reportPicker.delegate = self
        involvePicker.dataSource = self
        involvePicker.delegate = self
        
        reportTextBox.hidden = true;
        involveTextBox.hidden = true;
        
        reportTextBox.delegate = self
        involveTextBox.delegate = self
        
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func reportInfoPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Report Defintions", message: "Close Call - A situation that could have led to an injury or property damage, but did not.\n\nLesson Learned – Knowledge gained from a positive or negative experience.\n\nSafety Issue – Any action observed or participated in that can lead to injury or property damage.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func involveInfoPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Involvement Defintions", message: "Work Practice/Procedure – Examples include the use of outdated procedures and missing steps to complete the procedure/process safely and successfully.\n\nChemical – Examples include chemical spills and the use of improper Personal Protective Equipment while handling chemicals.\n\nEquipment – Examples include faulty equipment or the use of the wrong equipment for the task.\n\nWorkplace Condition – Examples include poor housekeeping (clutter), skipping/tripping hazards, and limited workspace to safely complete the task.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    var hasMoved = false
    
    @IBOutlet weak var incidentView: UITextView!
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        if !hasMoved && incidentView.isFirstResponder() {
            self.view.center.y = self.view.center.y - keyboardHeight
            hasMoved = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        if hasMoved && incidentView.isFirstResponder() {
            self.view.center.y = self.view.center.y + keyboardHeight
            hasMoved = false
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == reportPicker {
            return reportData.count
        } else {
            return involveData.count
        }
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == reportPicker {
            return reportData[row]
        } else {
            return involveData[row]
        }
    }
    
    var reportSelection: String = ""
    var involveSelection: String = ""
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == reportPicker {
            if row == 3 {
                reportTextBox.hidden = false;
            } else {
                reportTextBox.hidden = true;
            }
            reportSelection = reportData[row]
        } else {
            if row == 4 {
                involveTextBox.hidden = false;
            } else {
                involveTextBox.hidden = true;
            }
            involveSelection = involveData[row]
        }
    }
    
    @IBAction func saveInfoPress(sender: AnyObject) {
        if reportSelection == "Other" {
            finalReportData.reportKind = reportTextBox.text!
        } else {
            if reportSelection == "" {
                reportSelection = reportData[0]
            }
            finalReportData.reportKind = reportSelection
            //print("here")
        }
        if involveSelection == "Other" {
            finalReportData.involveKind = involveTextBox.text!
        } else {
            if involveSelection == "" {
                involveSelection = involveData[0]
            }
            finalReportData.involveKind = involveSelection
            //print("here")
        }
        finalReportData.incidentDesc = incidentView.text!
        
        self.view.endEditing(true)
        /*print("Report kind: \(finalReportData.reportKind)")
        print("Involve kind: \(finalReportData.involveKind)")
        print("Description: \(finalReportData.incidentDesc)")*/
    }
}
