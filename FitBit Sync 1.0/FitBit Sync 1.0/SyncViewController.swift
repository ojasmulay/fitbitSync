//
//  ThirdViewController.swift
//  FitBit Sync 1.0
//
//  Created by Mulay, Ojas on 5/7/16.
//  Copyright © 2016 Mulay, Ojas. All rights reserved.
//

import UIKit
import HealthKit;

class SyncViewController: UIViewController {
    
    
    @IBOutlet var FitbitSyncStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.FitbitSyncStatus.text = "Last Synced at ";
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfile(id: String)
    {
        let urlPath: String = "https://api.fitbit.com/1/user/-/profile.json"
        let url: NSURL = NSURL(string: urlPath)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        urlRequest.addValue("Bearer " + (id as String), forHTTPHeaderField: "Authorization");
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config);
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            //            // this is where the completion handler code goes
            let responseData = String(data: data!, encoding: NSUTF8StringEncoding);
            print("Response:" + (responseData! as String));
        });
        task.resume();
    }
    @IBAction func PerformSync(sender: AnyObject) {
        let responseData = self.getSleepSeries(accessToken);
        if(responseData != ""){
        UIAlertController (title: "Results", message: responseData, preferredStyle: UIAlertControllerStyle.Alert)
        }
    }
    //sleep/timeInBed
    func getSleepSeries(accessToken: String) -> String{
       var results = "";
        let urlPath: String = "https://api.fitbit.com/1/user/-/sleep/timeInBed/date/2016-04-02/7d.json"
        let url: NSURL = NSURL(string: urlPath)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        urlRequest.addValue("Bearer " + (accessToken as String), forHTTPHeaderField: "Authorization");
        
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config);
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
           
            let responseData = String(data: data!, encoding: NSUTF8StringEncoding);
            results =  responseData!;
            let dateformatter = NSDateFormatter();
            dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle;
            dispatch_async(dispatch_get_main_queue())
            {
            self.FitbitSyncStatus.text = "Last Synced at " + (dateformatter.stringFromDate(NSDate()));
              
            }
            print(self.FitbitSyncStatus.text);
//          UIAlertController (title: "Results", message: responseData, preferredStyle: UIAlertControllerStyle.Alert)
        });
        task.resume();
    return results;
        
    }
    
    func healthKitPermission(){
        let healthStore = HKHealthStore()
        
        // create an object type to request an authorization for a specific category, here is SleepAnalysis
        
        let sleepType = HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)
        
        healthStore.requestAuthorizationToShareTypes(NSSet(object: sleepType!) as! Set<HKSampleType>, readTypes: NSSet(object: sleepType!) as! Set<HKObjectType>, completion: {(success, error) -> Void in
            
            self.updateAppleHealth();
            
        })
    }
    
    func updateAppleHealth(){
        let healthStore:HKHealthStore = HKHealthStore();
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let startDate = formatter.dateFromString("2016/05/05 22:30");
        let endDate = formatter.dateFromString("2016/05/06 08:30");
        
        if let sleepType = HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis) {
            
            // we create our new object we want to push in Health app
            
            let object = HKCategorySample(type:sleepType, value: HKCategoryValueSleepAnalysis.InBed.rawValue, startDate: startDate!, endDate: endDate!)
            
            // at the end, we save it
            
            healthStore.saveObject(object, withCompletion: { (success, error) -> Void in
                
                if error != nil {
                    
                    // something happened
                    return
                    
                }
                
                if success {
                    print("My new data was saved in Healthkit", terminator: "")
                    
                } else {
                    // something happened again
                    
                }
                
            })
        }    }
    
    
}

