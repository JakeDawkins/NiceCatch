//: Playground - noun: a place where people can play

import UIKit
import SwiftHTTP

var str = "Hello, playground"

//let baseUrl = "localhost/api/?"
let baseUrl = "http://jsonplaceholder.typicode.com/"

//need report kinds and involvements
let url = NSURL(string: baseUrl + "posts/1")

let session = NSURLSession.sharedSession()

session.dataTaskWithURL(url!, completionHandler:
    { (data: NSData?, response:NSURLResponse?, error: NSError?) -> Void in
        do {
            //make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where realResponse.statusCode == 200 else {
                print ("not a 200 response")
                return
            }
            
            
            if let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding){
                //parse json
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let origin = jsonDictionary["origin"] as! String
                print(responseString)
            }
        } catch {
            print("bad things happened")
        }
}).resume();