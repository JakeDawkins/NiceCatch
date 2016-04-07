//
//  infoViewController.swift
//  NiceCatch
//
//  Created by Daniel Battle on 12/2/15.
//  Copyright © 2015 Daniel Battle. All rights reserved.
//

import Foundation
import UIKit

class infoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMutableString = NSMutableAttributedString(string: myString as String)
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: NSRange(location:114,length:19))

        hyperlink.attributedText = myMutableString
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoViewController.labelAction(_:)))
        hyperlink.addGestureRecognizer(tap)
        tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var hyperlink: UILabel!
    var myString:NSString = "If you have a serious safety or ethical concern but do not feel comfortable sharing your identity, please use the confidental hotline."
    var myMutableString = NSMutableAttributedString()
    
    // Receive action
    func labelAction(gr:UITapGestureRecognizer)
    {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://www.clemson.edu/administration/internalaudit/ethicsline.html")!)
    }
    

    
}