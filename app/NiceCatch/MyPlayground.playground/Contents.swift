//: Playground - noun: a place where people can play

import UIKit


func getDateTimeString() -> String{
    let now = NSDate()
    
    let dayTimePeriodFormatter = NSDateFormatter()
    dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    
    return dayTimePeriodFormatter.stringFromDate(now)
}


getDateTimeString()