//  PasswordViewController.swift
//  EffortlessAndSecureBanking
//
//  Created by Jasmine Lu on 09/02/2016.
//  Copyright © 2016 jasminelu. All rights reserved.
//

import UIKit
import LocalAuthentication
import SwiftyJSON
import CoreLocation

class PasswordViewController: UIViewController, CLLocationManagerDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var password: UITextField!
    var phoneNumberString:String!
    var passwordString:String!
    var fingerprint:Bool!
    @IBOutlet weak var loginResponse: UILabel!
    
    var count = 1
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //TODO MOVE THIS - LOCATION AUTHORIZATION
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let minute = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
        let absTime = (hour*60)+minute
        print("absolute time: ")
        print(absTime)
        
        let day = NSCalendar.currentCalendar().component(.Weekday, fromDate:NSDate())
        print("day of the week: ")
        print(day)
        
        // is fingerprint login enabled
        
        print(defaults.boolForKey("fingerprint"))
        
        //has this user already logged on
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")) {
            //gets the user's phone number
            phoneNumberString = defaults.stringForKey("phoneNumber")
            if (defaults.boolForKey("fingerprint")) {
                fingerprintAuthentication()
            }
        }

    }
    
    func roundCoord(value: Double, round: Double) -> Double {
        return 1;
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let long: Double = location.coordinate.longitude
        let lat: Double = location.coordinate.latitude
        
        let long1 = round(long * 10000)/10000
        let lat1 = round(lat * 10000)/10000
        
        let long2 = round(long * 100000)/100000
        let lat2 = round(lat * 100000)/100000
        
        locationManager.stopUpdatingLocation()
        
        if count == 1 {
            print("long1: ")
            print(long1)
            print("lat1: ")
            print(lat1)
        } else {
            print("long2: ")
            print(long2)
            print("lat2: ")
            print(lat2)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        //login password authentication with postgresql database
        
        passwordString = password.text
        
        if (passwordString.isEmpty) {
            
            let alertController = UIAlertController(title: "Error", message: "Enter Password", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Default) {(action) in
                self.fingerprint = true
                self.fingerprintAuthentication()
            }
            
            alertController.addAction(ok)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else {
            passwordLogin(passwordString)
        }
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")) {
            // app already launched
        }
        else {
            
            // This is the first launch ever
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(
                LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
                error: &error) {
                    // TouchID is available on the device
                    let alertController = UIAlertController(title: "Option", message: "Use TouchID for Login?", preferredStyle: .Alert)
                    
                    let yesOption = UIAlertAction(title: "Yes", style: .Default) {(action) in
                        print(action)
                        self.fingerprint = true
                        self.fingerprintAuthentication()
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setBool(true, forKey: "fingerprint")
                        //                print("yes")
                    }
                    let noOption = UIAlertAction(title: "No", style: .Default) {(action) in
                        print(action)
                        self.fingerprint = false
                        //                print("no")
                    }
                    
                    alertController.addAction(yesOption)
                    alertController.addAction(noOption)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // TouchID is not available on the device
                // No scanner or user has not set up TouchID
            }
            
        }
        
        return false
    }

    func passwordLogin(password: String) {
        count = count + 1
        
        let urlString = "http://esb.eu-gb.mybluemix.net/ibm/5ZVO0gX7Vy845sKhHwg0/"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                //TODO get ivan to assign an array name
                if json[0]["fields"]["testcasepass"].string == password {
                    self.locationManager.startUpdatingLocation()
                    
                    let vc = WelcomeViewController(nibName: nil, bundle: nil)
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                }
                else {
                    let alertController = UIAlertController(title: "Password Incorrect", message: "Please try again.", preferredStyle: .Alert)
                    let ok = UIAlertAction(title: "Ok", style: .Default) {(action) in
                        self.resignFirstResponder()
                    }
                    
                    alertController.addAction(ok)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            
        }
        
        /* TODO - replace above with this
         if user.fields.phonenumber = defaults - phone number
            if user.fields.password = passwordstring
                login
            else
                login failed
        */

    }
    
    func fingerprintLogin() {
        count = count + 1
        
        self.locationManager.startUpdatingLocation()
        let vc = WelcomeViewController(nibName: nil, bundle: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }

    //touch id authentication
    func fingerprintAuthentication() {
        let context : LAContext = LAContext()
        
        var error : NSError?
        let myLocalizedReasonString : NSString = "Unlock with your fingerprint"
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString as String, reply: {
                    (success : Bool, evaluationError : NSError?) -> Void in
                    if success {
                        self.fingerprintLogin()
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        })
                    }
                    else {
                        // Fingerprint Authentification Failed
                        print(evaluationError?.localizedDescription)
                        
                        switch evaluationError!.code {
                        case LAError.SystemCancel.rawValue:
                            print("Authentication cancelled by the system")
                        case LAError.UserCancel.rawValue:
                            print("Authentication cancelled by the user")
                        case LAError.UserFallback.rawValue:
                            print("User wants to use a password")
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            })
                        default:
                            print("Authentication failed")
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            })
                        }
                    }
                })
        }
        else {
            switch error!.code {
            case LAError.TouchIDNotEnrolled.rawValue:
                print("TouchID not enrolled")
            case LAError.PasscodeNotSet.rawValue:
                print("Passcode not set")
            default:
                print("TouchID not available")
            }
        }

        
    }
    
    @IBAction func signOut(sender: AnyObject) {
        
        defaults.removeObjectForKey("name")
        defaults.removeObjectForKey("fingerprint")
        defaults.removeObjectForKey("HasLaunchedOnce")
        defaults.removeObjectForKey("phoneNumber")
        defaults.synchronize()
        
        let vc = HomeViewController(nibName: nil, bundle: nil)
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
