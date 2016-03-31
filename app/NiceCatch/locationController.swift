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

class locationController: UIViewController,
UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    var useFilteredData = false
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var roomNumField: UITextField!
    
    @IBOutlet weak var buildingSearch: UISearchBar!
    @IBOutlet weak var buildingTable: UITableView!
    var filteredCampusBuildings = [String]()
    let otherBuildingNames = ["AMRL", "Ansell", "CETL", "Cherry Farm", "Endocrine Lab", "Environmental Tox", "Griffith", "HP Cooper", "ICAR", "Lashch Lab", "Patewood", "Pee Dee", "Pesticide Bldg", "Rich Lab", "Vet Diagnostic Center"]
    var filteredOtherBuildings = [String]()
    
    @IBOutlet weak var departmentSearch: UISearchBar!
    @IBOutlet weak var departmentTable: UITableView!
    var filteredDepartNames = [String]()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    //------------------------ KEYBOARD ------------------------
    
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
        }
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
        }
    }
    
    
    func filterContentForSearchText(searchText: String) {
        if buildingTable.hidden == false {
            if locSwitch.on {
                filteredOtherBuildings = otherBuildingNames.filter() { $0.lowercaseString.hasPrefix(searchText.lowercaseString) }
            } else {
                filteredCampusBuildings = preloadedData.buildingNames.filter() { $0.lowercaseString.hasPrefix(searchText.lowercaseString) }
            }
        } else {
            filteredDepartNames = preloadedData.departmentNames.filter() { $0.lowercaseString.hasPrefix(searchText.lowercaseString) }
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        if searchBar == buildingSearch {
            departmentTable.hidden = true
            buildingTable.hidden = false
            datePicker.hidden = true
            buildingTable.reloadData()
        } else {
            buildingTable.hidden = true
            departmentTable.hidden = false
            roomNumField.hidden = true
            departmentTable.reloadData()
        }
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        if searchBar == buildingSearch {
            buildingTable.hidden = true
            datePicker.hidden = false
        } else {
            departmentTable.hidden = true
            roomNumField.hidden = false
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
                    return preloadedData.buildingNames.count
                }
            }
        } else {
            if useFilteredData {
                return filteredDepartNames.count
            } else {
                return preloadedData.departmentNames.count
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
                    cell.textLabel?.text = preloadedData.buildingNames[indexPath.row]
                }
            }
            return cell
        } else {
            let cell2:UITableViewCell = departmentTable.dequeueReusableCellWithIdentifier("cell2")! as UITableViewCell
            if useFilteredData {
                cell2.textLabel?.text = filteredDepartNames[indexPath.row]
            } else {
                cell2.textLabel?.text = preloadedData.departmentNames[indexPath.row]
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
                    buildingSearch.text = preloadedData.buildingNames[indexPath.row]
                }
            }
            useFilteredData = false
            buildingTable.hidden = true
            self.view.endEditing(true)
        } else {
            if useFilteredData {
                departmentSearch.text = filteredDepartNames[indexPath.row]
            } else {
                departmentSearch.text = preloadedData.departmentNames[indexPath.row]
            }
            useFilteredData = false
            departmentTable.hidden = true
            self.view.endEditing(true)
        }
    }
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        finalReportData.departmentName = departmentSearch.text!
        finalReportData.buildingName = buildingSearch.text!
        finalReportData.roomNum = roomNumField.text!

        let deliveryTime = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        finalReportData.time = deliveryTime
    }

    //---------------- VALIDATION ----------------
    //determine whether to block segue or not
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if ((buildingSearch.text == "")
            || (departmentSearch.text == "")
            ){
            let alertController = UIAlertController(title: "Invalid Input", message: "You must select a building and Department", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {}
            
            return false
        }
        
        // by default, transition
        return true
    }

    
}