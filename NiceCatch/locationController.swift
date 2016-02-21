//
//  locationController.swift
//  NiceCatch
//
//  Created by Daniel Battle on 11/17/15.
//  Copyright © 2015 Daniel Battle. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class locationController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    let photoPicker = UIImagePickerController()
    var useFilteredData = false
    
    @IBOutlet var backgroundView: UIView!
    
    var buildings: Array<String> = []
    var jsonArray:NSMutableArray?
    var campusBuildingNames:Array<String> = []
    var departmentNames:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self
        buildingSearch.delegate = self
        departmentSearch.delegate = self
        
        buildingTable.delegate = self
        buildingTable.dataSource = self
        departmentTable.delegate = self
        departmentTable.dataSource = self
        
        self.buildingTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.departmentTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
        buildingTable.hidden = true
        departmentTable.hidden = true
        
        locSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        roomNumField.delegate = self
        
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        useFilteredData = false
        
        //------------------------ LOAD BUILDING NAMES FROM DB ------------------------
        Alamofire.request(.GET, "http://people.cs.clemson.edu/~jacksod/api/?controller=loader&action=getBuildings").responseJSON { response in
            
            if let JSON = response.result.value {
                self.jsonArray = JSON["data"] as? NSMutableArray
                if(self.jsonArray != nil){
                    for item in self.jsonArray! {
                        //print(item["buildingName"]!)
                        let string = item["buildingName"]!
                        //print("String is \(string!)")
                        
                        self.campusBuildingNames.append(string! as! String)
                    }
                }
                
                print("BuildingNames array is \(self.campusBuildingNames)")
            }
        }
        
        //------------------------ LOAD DEPARTMENT NAMES FROM DB ------------------------
        Alamofire.request(.GET, "http://people.cs.clemson.edu/~jacksod/api/?controller=loader&action=getDepartments").responseJSON { response in
            
            if let JSON = response.result.value {
                self.jsonArray = JSON["data"] as? NSMutableArray
                if(self.jsonArray != nil){
                    for item in self.jsonArray! {
                        //print(item["buildingName"]!)
                        let string = item["departmentName"]!
                        //print("String is \(string!)")
                        
                        self.departmentNames.append(string! as! String)
                    }
                }
                
                print("departmentNames array is \(self.departmentNames)")
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
    
    @IBOutlet weak var roomNumField: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    var hasMoved = false
    
    @IBOutlet weak var incidentView: UITextView!
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        if !hasMoved && departmentSearch.isFirstResponder() {
            self.view.center.y = self.view.center.y - keyboardHeight + CGFloat(90)
            hasMoved = true
        } else if !hasMoved && buildingSearch.isFirstResponder() {
            //print("here")
            self.view.center.y = self.view.center.y - keyboardHeight + CGFloat(50)
            hasMoved = true
            view.bringSubviewToFront(buildingTable)
        } /*else if !hasMoved {
            self.view.center.y = self.view.center.y - keyboardHeight + CGFloat(30)
            hasMoved = true
        }*/
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        if hasMoved && departmentSearch.isFirstResponder() {
            self.view.center.y = self.view.center.y + keyboardHeight - CGFloat(90)
            hasMoved = false
        } else if hasMoved && buildingSearch.isFirstResponder() {
            self.view.center.y = self.view.center.y + keyboardHeight - CGFloat(50)
            hasMoved = false
        } /*else if hasMoved {
            self.view.center.y = self.view.center.y + keyboardHeight - CGFloat(30)
            hasMoved = false
        }*/
    }
    
    @IBOutlet weak var buildingSearch: UISearchBar!
    @IBOutlet weak var buildingTable: UITableView!
    //let campusBuildingNames = ["Brackett Hall", "BRC", "Brooks Center", "Cook Lab", "Earle Hall", "Fluor Daniel", "Freeman Hall", "Godfrey", "Godley Snell", "Harris A. Smith", "Hunter Hall", "Jordan", "Kinard Lab", "Lee Hall", "Lehotsky Hall", "Life Science", "Long Hall", "Lowry", "McAdams Hall", "Newman Hall", "Olin Hall", "Poole", "Ravenel", "Rhodes Annex", "Rhodes Hall", "Riggs", "Sirrine Hall"]
    var filteredCampusBuildings = [String]()
    let otherBuildingNames = ["AMRL", "Ansell", "CETL", "Cherry Farm", "Endocrine Lab", "Environmental Tox", "Griffith", "HP Cooper", "ICAR", "Lashch Lab", "Patewood", "Pee Dee", "Pesticide Bldg", "Rich Lab", "Vet Diagnostic Center"]
    var filteredOtherBuildings = [String]()
    
    @IBOutlet weak var departmentSearch: UISearchBar!
    @IBOutlet weak var departmentTable: UITableView!
    /*let departmentNames = ["Agricultural & Environmental Sciences", "Animal & Veterinary Sciences", "Architecture", "Art", "Automotive Engineering", "Bioengineering", "Biological Sciences", "Chemical & Biomolecular Engineering", "Chemistry", "Civil Engineering", "Construction Science & Management", "Electrical & Computer Engineering", "Environmental Engineering", "Food, Nutrition & Packaging Science", "Forestry & Environmetnal Conservaton", "Genetics & Biochemistry", "Materials Science & Engineering", "Mechanical Engineering", "Nursing", "Physics & Astronomy", "Public Health Sciences"]*/
    var filteredDepartNames = [String]()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    func filterContentForSearchText(searchText: String) {
        if buildingTable.hidden == false {
            if locSwitch.on {
                filteredOtherBuildings = otherBuildingNames.filter() { $0.lowercaseString.hasPrefix(searchText.lowercaseString) }
            } else {
                filteredCampusBuildings = campusBuildingNames.filter() { $0.lowercaseString.hasPrefix(searchText.lowercaseString) }
            }
        } else {
            filteredDepartNames = departmentNames.filter() { $0.lowercaseString.hasPrefix(searchText.lowercaseString) }
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        if searchBar == buildingSearch {
            departmentTable.hidden = true
            buildingTable.hidden = false
            buildingTable.reloadData()
        } else {
            buildingTable.hidden = true
            departmentTable.hidden = false
            departmentTable.reloadData()
        }
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        if searchBar == buildingSearch {
            buildingTable.hidden = true
        } else {
            departmentTable.hidden = true
        }
        return true
    }
    
    @IBOutlet weak var locSwitch: UISwitch!
    
    func stateChanged(switchState: UISwitch) {
        buildingTable.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar == buildingSearch) {
            departmentTable.hidden = true
            buildingTable.hidden = false
            if searchBar.text?.characters.count != 0 {
                useFilteredData = true
                filterContentForSearchText(buildingSearch.text!)
            } else {
                useFilteredData = false
            }
            buildingTable.reloadData()
        } else {
            buildingTable.hidden = true
            departmentTable.hidden = false
            if searchBar.text?.characters.count != 0 {
                useFilteredData = true
                filterContentForSearchText(departmentSearch.text!)
            } else {
                useFilteredData = false
            }
            departmentTable.reloadData()
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == buildingTable {
            if useFilteredData {
                if locSwitch.on {
                    return filteredOtherBuildings.count
                } else {
                    return filteredCampusBuildings.count
                }
            } else {
                if locSwitch.on {
                    return otherBuildingNames.count
                } else {
                    return campusBuildingNames.count
                }
            }
        } else {
            if useFilteredData {
                return filteredDepartNames.count
            } else {
                return departmentNames.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == buildingTable {
            let cell:UITableViewCell = buildingTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            if useFilteredData {
                if locSwitch.on {
                    cell.textLabel?.text = filteredOtherBuildings[indexPath.row]
                } else {
                    cell.textLabel?.text = filteredCampusBuildings[indexPath.row]
                }
            } else {
                if locSwitch.on {
                    cell.textLabel?.text = otherBuildingNames[indexPath.row]
                } else {
                    cell.textLabel?.text = campusBuildingNames[indexPath.row]
                }
            }
            return cell
        } else {
            let cell2:UITableViewCell = departmentTable.dequeueReusableCellWithIdentifier("cell2")! as UITableViewCell
            if useFilteredData {
                cell2.textLabel?.text = filteredDepartNames[indexPath.row]
            } else {
                cell2.textLabel?.text = departmentNames[indexPath.row]
            }
            return cell2
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == buildingTable {
            if useFilteredData {
                if locSwitch.on {
                    buildingSearch.text = filteredOtherBuildings[indexPath.row]
                } else {
                    buildingSearch.text = filteredCampusBuildings[indexPath.row]
                }
            } else {
                if locSwitch.on {
                    buildingSearch.text = otherBuildingNames[indexPath.row]
                } else {
                    buildingSearch.text = campusBuildingNames[indexPath.row]
                }
            }
            useFilteredData = false
            buildingTable.hidden = true
            self.view.endEditing(true)
        } else {
            if useFilteredData {
                departmentSearch.text = filteredDepartNames[indexPath.row]
            } else {
                departmentSearch.text = departmentNames[indexPath.row]
            }
            useFilteredData = false
            departmentTable.hidden = true
            self.view.endEditing(true)
        }
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    
    //MARK: Delegates
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
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        finalReportData.departmentName = departmentSearch.text!
        finalReportData.buildingName = buildingSearch.text!
        finalReportData.roomNum = roomNumField.text!
        
        let deliveryTime = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        finalReportData.time = deliveryTime
        
        /*print("Department Name: \(finalReportData.departmentName)")
        print("Building Name: \(finalReportData.buildingName)")
        print("Time: \(finalReportData.roomNum)")
        print("Time: \(finalReportData.time)")*/
    }

}