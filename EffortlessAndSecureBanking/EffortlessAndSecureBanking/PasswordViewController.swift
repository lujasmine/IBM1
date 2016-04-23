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
import Alamofire

class PasswordViewController: UIViewController, CLLocationManagerDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var predictionResultLabel: UILabel!
    
    
    @IBOutlet weak var password: UITextField!
    var phoneNumberString:String!
    var passwordString:String!
    var fingerprint:Bool!
    @IBOutlet weak var loginResponse: UILabel!
    
    var longitude:Double!
    var latitude:Double!
    var time:Int!
    var day:Int!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //has this user already logged on
        if(NSUserDefaults.standardUserDefaults().boolForKey("loggedIn")) {
            //gets the user's phone number
            phoneNumberString = defaults.stringForKey("phoneNumber")
            if defaults.boolForKey("predio") {
                getProperties()
            }
            
            if (defaults.boolForKey("fingerprint")) {
                fingerprintAuthentication()
            }
        }
        
    }
    
    func getProperties() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let minute = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
        
        time = (hour*60)+minute
        day = NSCalendar.currentCalendar().component(.Weekday, fromDate:NSDate())
        

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let long: Double = location.coordinate.longitude
        let lat: Double = location.coordinate.latitude
        
        longitude = round(long * 100000)/100000
        latitude = round(lat * 100000)/100000
        
        locationManager.stopUpdatingLocation()
        
        //TODO ask query - prediction login
        
        Alamofire.request(.GET, "http://esb-php.eu-gb.mybluemix.net/predict.php?time=\(time)&day=\(day)&latitude=\(latitude)&longitude=\(longitude)").response { (req, res, data, error) -> Void in
            
            let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            print(outputString)
            
            if outputString == "-1" {
                self.predictionResultLabel.text = "Could not login with Prediction Engine"
            } else {
                let vc = WelcomeViewController(nibName: nil, bundle: nil)
                vc.predLogin = true
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        passwordString = password.text
        
        if (passwordString.isEmpty) {
            
            let alertController = UIAlertController(title: "Error", message: "Enter Password", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else {
            passwordLogin(passwordString)
        }
        
        return false
    }
    
    func askToUseFingerprint() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // TouchID is available on the device
            
            let alertView = UIAlertController(title: "Login Option", message: "Use TouchID for Login?", preferredStyle: .Alert)
            
            let yesOption = UIAlertAction(title: "Yes", style: .Default) {(action) in
                self.fingerprintAuthentication()
                self.defaults.setBool(true, forKey: "fingerprint")
            }
            let noOption = UIAlertAction(title: "No", style: .Default) {(action) in
                self.defaults.setBool(false, forKey: "fingerprint")
            }
            
            alertView.addAction(yesOption)
            alertView.addAction(noOption)
            
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func passwordLogin(password: String) {
        
        let urlString = "http://esb.eu-gb.mybluemix.net/ibm/p9qdULz6sU9mpFoyDiJovWY4hGy4eFLW3319uoKXq531FoPYnbi3VVutY5t8tDO3"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                                
                if json[defaults.integerForKey("count")]["fields"]["testcasepass"].string == password {
                    
                    if !defaults.boolForKey("loggedIn") {
                        askToUseFingerprint()
                    }
                    
                    if defaults.boolForKey("predio") {
                        self.locationManager.startUpdatingLocation()
                    }
                    
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
        
    }
    
    func fingerprintLogin() {
        
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
        defaults.removeObjectForKey("loggedIn")
        defaults.removeObjectForKey("phoneNumber")
        defaults.removeObjectForKey("predio")
        defaults.removeObjectForKey("count")
        defaults.synchronize()
        
        print(defaults.boolForKey("loggedIn"))
        
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
