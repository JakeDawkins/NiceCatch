//
//  ViewController.swift
//  NiceCatch
//
//  Created by Daniel Battle on 11/8/15.
//  Copyright © 2015 Daniel Battle. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if MyVariables.isSubmitted {
            presentThankYou()
            clearData()
            MyVariables.isSubmitted = false
        }
    }
    
    func presentThankYou() {
        let alert = UIAlertController(title: "Thank You!", message: "Thank you for submitting a Nice Catch! report. The Research Safety office will review your report.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func clearData() {
        finalReportData.reportKind = ""
        finalReportData.involveKind = ""
        finalReportData.incidentDesc = ""
        finalReportData.image = UIImage()
        finalReportData.departmentName = ""
        finalReportData.buildingName = ""
        finalReportData.roomNum = ""
        finalReportData.time = ""
        finalReportData.designation = ""
        finalReportData.name = ""
        finalReportData.username = ""
        finalReportData.phoneNum = ""
    }
    
}

