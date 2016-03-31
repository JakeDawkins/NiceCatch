//
//  finalReportData.swift
//  NiceCatch
//
//  Created by Daniel Battle on 11/22/15.
//  Copyright © 2015 Daniel Battle. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct finalReportData {
    static var reportKind: String = ""
    static var involveKind: String = ""
    static var incidentDesc: String = ""
    static var image: UIImage = UIImage()
    static var departmentName: String = ""
    static var buildingName: String = ""
    static var roomNum: String = ""
    static var time: String = ""
    static var designation: String = ""
    static var name: String = ""
    static var username: String = ""
    static var phoneNum: String = ""
    static var remoteID: Int = -1
}

struct preloadedData {
    static var involvementKinds: [String] = []
    static var reportKinds: [String] = []
    static var buildingNames: [String] = []
    static var departmentNames: [String] = []
    static var personKinds: [String] = []
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
    
    preloadedData.involvementKinds = []
    preloadedData.reportKinds = []
    preloadedData.buildingNames = []
    preloadedData.departmentNames = []
    preloadedData.personKinds = []
}

func preload(){
    //-------- LOAD INVOLVEMENT NAMES FROM DB --------
    Alamofire.request(.GET, "https://people.cs.clemson.edu/~jacksod/api/v1/involvements").responseJSON { response in
        if let JSON = response.result.value {
            let jsonArray = JSON["data"] as? NSMutableArray
            if(jsonArray != nil){
                for item in jsonArray! {
                    let string = item["involvementKind"]!
                    preloadedData.involvementKinds.append(string! as! String)
                }
            }
            print("involvementKinds array is \(preloadedData.involvementKinds)")
        }
    }
    
    //-------- LOAD REPORT KINDS FROM DB --------
    Alamofire.request(.GET, "https://people.cs.clemson.edu/~jacksod/api/v1/reportKinds").responseJSON { response in
        if let JSON = response.result.value {
            let jsonArray = JSON["data"] as? NSMutableArray
            if(jsonArray != nil){
                for item in jsonArray! {
                    let string = item["reportKind"]!
                    preloadedData.reportKinds.append(string! as! String)
                }
            }
            print("reportKinds array is \(preloadedData.reportKinds)")
        }
    }
    
    //------------------------ LOAD BUILDING NAMES FROM DB ------------------------
    Alamofire.request(.GET, "https://people.cs.clemson.edu/~jacksod/api/v1/buildings").responseJSON { response in
        if let JSON = response.result.value {
            let jsonArray = JSON["data"] as? NSMutableArray
            if(jsonArray != nil){
                for item in jsonArray! {
                    let string = item["buildingName"]!
                    preloadedData.buildingNames.append(string! as! String)
                }
            }
            print("buildings array is \(preloadedData.buildingNames)")
        }
    }
    
    //------------------------ LOAD DEPARTMENT NAMES FROM DB ------------------------
    Alamofire.request(.GET, "https://people.cs.clemson.edu/~jacksod/api/v1/departments").responseJSON { response in
        if let JSON = response.result.value {
            let jsonArray = JSON["data"] as? NSMutableArray
            if(jsonArray != nil){
                for item in jsonArray! {
                    let string = item["departmentName"]!
                    preloadedData.departmentNames.append(string! as! String)
                }
            }
            print("departments array is \(preloadedData.departmentNames)")
        }
    }
    
    //------------------------ LOAD DESIGNATION NAMES FROM DB ------------------------
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
        }
    }
}