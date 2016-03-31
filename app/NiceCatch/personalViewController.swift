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
import SwiftyJSON

struct MyVariables {
    static var isSubmitted = false
}

class personalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var designTextField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var designPicker: UIPickerView!
    
    //------------------------ UI METHODS ------------------------
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(personalViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(personalViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        photoPicker.delegate = self
        
        designPicker.dataSource = self
        designPicker.delegate = self
        designTextField.hidden = true
        
        designTextField.delegate = self
        nameField.delegate = self
        usernameField.delegate = self
        phoneNumField.delegate = self
        
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(personalViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(personalViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        //not loaded. load manually
        if(preloadedData.personKinds.count == 0){
            self.loadPersonKinds()
        }
        
        activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //------------------------ DATA LOADING ------------------------
    func loadPersonKinds(){
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~jacksod/api/v1/personKinds").responseJSON { response in
            if let JSON = response.result.value {
                let jsonArray = JSON["data"] as? NSMutableArray
                if(jsonArray != nil){
                    for item in jsonArray! {
                        let string = item["personKind"]!
                        preloadedData.personKinds.append(string! as! String)
                    }
                }
                print("personKinds array is \(preloadedData.personKinds)")
                self.designPicker.reloadAllComponents()
            }
        }
    }
    
    //Images
    let photoPicker = UIImagePickerController()
    @IBOutlet weak var myImageView: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        myImageView.contentMode = .ScaleAspectFit
        myImageView.image = chosenImage
        finalReportData.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func takePhotoClicked(sender: AnyObject) {
        if (UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil) {
            photoPicker.sourceType = .Camera
            presentViewController(photoPicker, animated: true, completion: nil)
        } else {
            // Do nothing
        }
    }
    
    @IBAction func uploadPhotoClicked(sender: AnyObject) {
        photoPicker.allowsEditing = false
        photoPicker.sourceType = .PhotoLibrary
        presentViewController(photoPicker, animated: true, completion: nil)
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
        
        if !hasMoved { //&& phoneNumField.isFirstResponder() {
            self.view.center.y = self.view.center.y - keyboardHeight + CGFloat(50)
            hasMoved = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        if hasMoved { //&& phoneNumField.isFirstResponder() {
            self.view.center.y = self.view.center.y + keyboardHeight - CGFloat(50)
            hasMoved = false
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return preloadedData.personKinds.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return preloadedData.personKinds[row]
    }
    
    var designSelection: String = ""
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if preloadedData.personKinds[row] == "Other" {
            designTextField.hidden = false;
        } else {
            designTextField.hidden = true;
        }
        designSelection = preloadedData.personKinds[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = preloadedData.personKinds[row]
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
    
    func addPersonalInfo() {
        if designSelection == "Other" {
            finalReportData.designation = designTextField.text!
        } else if designSelection == "" {
            finalReportData.designation = "Faculty"
        } else {
            finalReportData.designation = designSelection
        }
        finalReportData.name = nameField.text!
        finalReportData.username = usernameField.text!
        finalReportData.phoneNum = phoneNumField.text!
    }
    
    
    //------------------------ ACTION HANDLERS ------------------------

    //This submits the form and calls method to save to DB
    @IBAction func submitClicked(sender: AnyObject) {
        MyVariables.isSubmitted = true
        self.addPersonalInfo()
        self.addToDatabase()
    }
    
    //------------------------ HELPER METHODS ------------------------
    
    func addToDatabase() {
        //-------- VALIDATION --------
        if ((designSelection == "Other" && designTextField.text == "")
            || (nameField.text == "")
            || (usernameField.text == "")
            ){
            let alertController = UIAlertController(title: "Invalid Input", message: "Missing Required Fields", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {}
            
            return
        }
        
        //animate until uploaded
        activityIndicator.startAnimating()
        
        //there is an image to upload.
        if(myImageView.image != nil){
            myImageView.alpha = 0.5
        }
        
        let params = [
            "description":finalReportData.incidentDesc,
            "involvementKind":finalReportData.involveKind,
            "reportKind":finalReportData.reportKind,
            "buildingName":finalReportData.buildingName,
            "room":finalReportData.roomNum,
            "personKind":finalReportData.designation,
            "name":finalReportData.name,
            "username":finalReportData.username,
            "phone":finalReportData.phoneNum,
            "department":finalReportData.departmentName,
            "dateTime":self.getDateTimeString(),
            "statusID":"1", //open report id (for all new reports)
            "actionTaken":""
        ]
        
        Alamofire.request(.POST, "https://people.cs.clemson.edu/~jacksod/api/v1/reports", parameters: params).responseJSON { response in
            if let _ = response.result.value {
                let json = JSON(data: response.data!)
                //print(json)
                
                let jsonData = json["data"]
                //print(jsonData)
                
                if let remoteID = Int(jsonData["id"].stringValue){
                    print("remote id: \(remoteID)")
                    finalReportData.remoteID = remoteID
                    if(self.myImageView.image != nil){
                        self.uploadPhoto()
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.presentThankYou()
                    }
                } else {
                    print("error getting remote ID")
                    return
                }
            }//if let _
        }//request
    }//func
    
    func uploadPhoto(){
        print("photo upload")
        
        let myUrl = NSURL(string: "https://people.cs.clemson.edu/~jacksod/api/v1/reports/\(finalReportData.remoteID)/photo");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "description":finalReportData.incidentDesc,
            "involvementKind":finalReportData.involveKind,
            "reportKind":finalReportData.reportKind,
            "buildingName":finalReportData.buildingName,
            "room":finalReportData.roomNum,
            "personKind":finalReportData.designation,
            "name":finalReportData.name,
            "username":finalReportData.username,
            "phone":finalReportData.phoneNum,
            "department":finalReportData.departmentName,
            "dateTime":self.getDateTimeString(),
            "statusID":"1", //open report id (for all new reports)
            "actionTaken":""
        ]
        
        let boundary = "Boundary-\(NSUUID().UUIDString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let imageData = UIImageJPEGRepresentation(finalReportData.image, 1)
        let imageData = UIImagePNGRepresentation(finalReportData.image)
        
        //no image, return
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "photo", imageDataKey: imageData!, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            print("Task completed")
            if let data = data {
                do {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        dispatch_async(dispatch_get_main_queue(), {
                            print(jsonResult)
                            self.activityIndicator.stopAnimating()
                            self.presentThankYou()
                        })
                    } //if let jsonResult
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }//func
    
    //------------------------ HELPER METHODS ------------------------
    
    //popup window that appears after submission
    func presentThankYou() {
        let alert = UIAlertController(title: "Thank You!", message: "Thank you for submitting a Nice Catch! report. The Research Safety office will review your report.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "report-image.png"
        
        let mimetype = "image/png"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }//func
    
    func getDateTimeString() -> String{
        let now = NSDate()
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return dayTimePeriodFormatter.stringFromDate(now)
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}