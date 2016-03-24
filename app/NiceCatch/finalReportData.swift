//
//  finalReportData.swift
//  NiceCatch
//
//  Created by Daniel Battle on 11/22/15.
//  Copyright © 2015 Daniel Battle. All rights reserved.
//

import Foundation
import UIKit

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
}

struct preloadedData {
    static var involvements: [String] = []
    static var reportKinds: [String] = []
    static var buildings: [String] = []
    static var departments: [String] = []
    static var personKinds: [String] = []
}