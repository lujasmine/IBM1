//
//  HomeViewController.swift
//  EffortlessAndSecureBanking
//
//  Created by Jasmine Lu on 09/02/2016.
//  Copyright © 2016 jasminelu. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    var phoneNumberString:String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func endEditingNow(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let doneButton = UIToolbar()
        doneButton.sizeToFit()
        
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.endEditingNow) )
        let toolbarButtons = [item]
        
        doneButton.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = doneButton
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.resignFirstResponder()
        
        let phone = phoneNumber.text
        
        if phone!.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "Enter Phone Number", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Default) {(action) in
                self.resignFirstResponder()
            }
            
            alertController.addAction(ok)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            phoneNumberString = phoneNumber.text
            checkPhone(phoneNumberString)
//            checkPhoneNumberExists()
        }
        
    }
    
    func checkPhone(phone: String) {
        
        let urlString = "http://esb.eu-gb.mybluemix.net/ibm/p9qdULz6sU9mpFoyDiJovWY4hGy4eFLW3319uoKXq531FoPYnbi3VVutY5t8tDO3"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                
                var count = 0
                
                for item in json.array! {
                    
                    if item["fields"]["phonenumber"].string == phone {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue(self.phoneNumber.text, forKey: "phoneNumber")
                        defaults.setValue(json[0]["fields"]["username"].string, forKey: "name")
                        defaults.setInteger(count, forKey: "count")
                        
                        let vc = PasswordViewController(nibName: nil, bundle: nil)
                        self.presentViewController(vc, animated: true, completion: nil)
                        
                        vc.phoneNumberString = self.phoneNumber.text
                    } else {
                        count = count + 1
                    }
                    
                }
                
                let alertController = UIAlertController(title: "Phone Number Incorrect", message: "Please try again.", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Default) {(action) in
                    self.resignFirstResponder()
                }
                
                alertController.addAction(ok)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
        }
    }
    
//    func checkPhoneNumberExists() {
//        Alamofire.request(.GET, "http://esb-php.eu-gb.mybluemix.net/checkPhone.php?phone=\(phoneNumberString)").response { (req, res, data, error) -> Void in
//            let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
//            print(outputString)
//            if (outputString == "Incorrect Phone Number " || outputString == "") {
//                let alertController = UIAlertController(title: "Phone Number Incorrect", message: "Please try again.", preferredStyle: .Alert)
//                let ok = UIAlertAction(title: "Ok", style: .Default) {(action) in
//                    self.resignFirstResponder()
//                }
//                
//                alertController.addAction(ok)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
//            else {
//                print(outputString)
//                let defaults = NSUserDefaults.standardUserDefaults()
//                defaults.setValue(self.phoneNumber.text, forKey: "phoneNumber")
//                
//                let vc = PasswordViewController(nibName: nil, bundle: nil)
//                self.presentViewController(vc, animated: true, completion: nil)
//                
//                vc.phoneNumberString = self.phoneNumber.text
//            }
//            
//        }
//        
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
