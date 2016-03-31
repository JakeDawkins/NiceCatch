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
import Alamofire

class reportController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var reportData: Array<String> = []
    var involveData: Array<String> = []
    var jsonArray:NSMutableArray?

    @IBOutlet weak var reportPicker: UIPickerView!
    @IBOutlet weak var involvePicker: UIPickerView!
    
    //these are hidden "other" text fields
    @IBOutlet weak var reportTextBox: UITextField!
    @IBOutlet weak var involveTextBox: UITextField!
    
    @IBOutlet weak var incidentView: UITextView!
    
    //------------------------ UI Methods ------------------------
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(personalViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(personalViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reportPicker.dataSource = self
        reportPicker.delegate = self
        involvePicker.dataSource = self
        involvePicker.delegate = self
        reportTextBox.delegate = self
        involveTextBox.delegate = self
        
        //these are hidden "other" text fields
        reportTextBox.hidden = true;
        involveTextBox.hidden = true;
        
        // Keyboard hiding
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(reportController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(reportController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reportController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //-------- LOAD REPORT KINDS FROM DB --------
        Alamofire.request(.GET, "http://people.cs.clemson.edu/~jacksod/api/v1/reportKinds").responseJSON { response in
            if let JSON = response.result.value {
                self.jsonArray = JSON["data"] as? NSMutableArray
                if(self.jsonArray != nil){
                    for item in self.jsonArray! {
                        let string = item["reportKind"]!
                        self.reportData.append(string! as! String)
                    }
                }
                //print("reportData array is \(self.reportData)")
            }
            //update the picker
            self.reportPicker.reloadAllComponents()
        }
        
        //-------- LOAD INVOLVEMENT NAMES FROM DB --------
        Alamofire.request(.GET, "http://people.cs.clemson.edu/~jacksod/api/v1/involvements").responseJSON { response in
            if let JSON = response.result.value {
                self.jsonArray = JSON["data"] as? NSMutableArray
                if(self.jsonArray != nil){
                    for item in self.jsonArray! {
                        let string = item["involvementKind"]!
                        self.involveData.append(string! as! String)
                    }
                }
                //print("involveData array is \(self.involveData)")
            }
            //update the picker
            self.involvePicker.reloadAllComponents()
        }
    }//end viewDidLoad
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------ KEYBOARD METHODS ------------------------
    
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
    
    var hasMoved = false
    
    //begin editing
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        if !hasMoved && incidentView.isFirstResponder() {
            self.view.center.y = self.view.center.y - keyboardHeight
            hasMoved = true
        }
    }
    
    //done editing
    func keyboardWillHide(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        if hasMoved && incidentView.isFirstResponder() {
            self.view.center.y = self.view.center.y + keyboardHeight
            hasMoved = false
        }
    }
    //------------------------ ACTION HANDLERS ------------------------
    
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
    
    @IBAction func saveInfoPress(sender: AnyObject) {
        if reportSelection == "Other" {
            finalReportData.reportKind = reportTextBox.text!
        } else {
            if reportSelection == "" {
                reportSelection = reportData[0]
            }
            finalReportData.reportKind = reportSelection
        }
        if involveSelection == "Other" {
            finalReportData.involveKind = involveTextBox.text!
        } else {
            if involveSelection == "" {
                involveSelection = involveData[0]
            }
            finalReportData.involveKind = involveSelection
        }
        finalReportData.incidentDesc = incidentView.text!
        
        self.view.endEditing(true)
    }
    
    //------------------------ PICKER METHODS ------------------------
    
    //how many pickers are in the view (always 1 in this case)
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //determines how many rows of data are in the picker
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == reportPicker {
            return reportData.count
        } else {
            return involveData.count
        }
    }
    
    //populates picker, depending on which picker view calls the method
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == reportPicker {
            return reportData[row]
        } else {
            return involveData[row]
        }
    }
    
    //identifies what item the user chose
    var reportSelection: String = ""
    var involveSelection: String = ""
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == reportPicker {
            if reportData[row] == "Other" {
                reportTextBox.hidden = false
            } else {
                reportTextBox.hidden = true
            }
            reportSelection = reportData[row]
        } else {
            if involveData[row] == "Other" {
                involveTextBox.hidden = false
            } else {
                involveTextBox.hidden = true
            }
            involveSelection = involveData[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        var titleData:String
        if pickerView == reportPicker {
            titleData = reportData[row]
        } else {
            titleData = involveData[row]
        }
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular) {
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 36.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .Center
            return pickerLabel
        } else {
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 24.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .Center
            return pickerLabel
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular) {
            return 36.0
        } else {
            return 30.0
        }
    }
}
