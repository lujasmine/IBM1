//
//  PasswordViewController.swift
//  EffortlessAndSecureBanking
//
//  Created by Jasmine Lu on 09/02/2016.
//  Copyright © 2016 jasminelu. All rights reserved.
//

import UIKit
import LocalAuthentication
import Alamofire
import SwiftyJSON

class PasswordViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    var phoneNumberString:String!
    var passwordString:String!
    var fingerprint:Bool!
    @IBOutlet weak var loginResponse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let defaults = NSUserDefaults.standardUserDefaults()
        print(defaults.boolForKey("fingerprint"))
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")) {
            // app already launched
            phoneNumberString = defaults.stringForKey("phoneNumber")
            if (defaults.boolForKey("fingerprint")) {
                fingerprintAuthentication()
            }
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
            passwordLogin()
        }
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")) {
            // app already launched
        }
        else {
            // This is the first launch ever
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let alertController = UIAlertController(title: "Option", message: "Use TouchID for authentication?", preferredStyle: .Alert)
            
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
        }
        
        return false
    }

    func passwordLogin() {
        Alamofire.request(.GET, "http://localhost/~jasminelu/password.php?phone=\(phoneNumberString)&password=\(passwordString)").response { (req, res, data, error) -> Void in
            let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            print(outputString)
            if outputString == "Login Failed" {
                self.loginResponse.text = "Login Failed"
            }
            else {
                self.loginResponse.text = "Welcome, " + (outputString?.capitalizedString)!
            }
            
        }
        
    }
    
    func fingerprintLogin() {
        Alamofire.request(.GET, "http://localhost/~jasminelu/fingerprint.php?phone=\(phoneNumberString)").response { (req, res, data, error) -> Void in
            let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            print(outputString)
            if outputString == "Login Failed" {
                self.loginResponse.text = "Login Failed"
            }
            else {
                self.loginResponse.text = "Welcome, " + (outputString?.capitalizedString)!
            }
            
        }
        
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
                        // Authentification failed
                        print(evaluationError?.localizedDescription)
                        
                        switch evaluationError!.code {
                        case LAError.SystemCancel.rawValue:
                            print("Authentication cancelled by the system")
                        case LAError.UserCancel.rawValue:
                            print("Authentication cancelled by the user")
                        case LAError.UserFallback.rawValue:
                            print("User wants to use a password")
                            // We show the alert view in the main thread (always update the UI in the main thread)
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                                self.showPasswordAlert()
                            })
                        default:
                            print("Authentication failed")
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                                self.showPasswordAlert()
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
//            self.showPasswordAlert()
        }

        
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
