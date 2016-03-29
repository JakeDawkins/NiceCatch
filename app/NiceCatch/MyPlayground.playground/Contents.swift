//: Playground - noun: a place where people can play

import UIKit
import SwiftyJSON
import Alamofire


let data = "{\"data\" : {\"dateTime\" : \"2016-02-25 11:13:01\",\"statusID\" : \"1\",\"id\" : \"11\",\"personID\" : \"7\",\"reportKindID\" : \"1\",\"actionTaken\" : \"\",\"photoPath\" : null,\"description\" : \"Test\",\"involvementKindID\" : \"1\",\"locationID\" : \"14\",\"departmentID\" : \"2\"},\"message\" : \"\"}"

let myData = data.dataUsingEncoding(NSUTF8StringEncoding)

let json = JSON(data: myData!)
//print(json)

let jsonData = json["data"]
//print(jsonData)

if let remoteID = Int(jsonData["id"].stringValue){
    print("remote id: \(remoteID)")
}



