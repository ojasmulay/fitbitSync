//
//  TestViewController.swift
//  FitBit Sync 1.0
//
//  Created by Mulay, Ojas on 5/7/16.
//  Copyright © 2016 Mulay, Ojas. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import HealthKit;

let AuthenticationNotification = "OAuthNotification";
var accessToken:String = "";
class MainViewController: UIViewController {
    
    
    
    private var urlString:String = "https://www.fitbit.com/oauth2/authorize?response_type=token&client_id=227Q99&redirect_uri=iSync://myapp.com%2ffitbit_auth&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&expires_in=604800&prompt=login%20consent"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.LoginResponse(_:)), name: AuthenticationNotification, object: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openWithSafariVC(sender: AnyObject)
    {
        let url = NSURL(string: self.urlString)!
        UIApplication.sharedApplication().openURL(url)
        //BUG: Using Safari view does not open the app after auth. Need to resolve
             // let svc = SFSafariViewController(URL: NSURL(string: self.urlString)!)
               // self.presentViewController(svc, animated: true, completion: nil)
        
    }
    
    func LoginResponse(notification: NSNotification) {
        let url = notification.object as! NSURL
        let URLString: NSString = url.absoluteString;
        
          accessToken = URLString.componentsSeparatedByString("=").last!;
        print("Value:" + (accessToken as String), terminator: "");
        self.performSegueWithIdentifier("options", sender: self)
       
    }
    
   
    
    
}

