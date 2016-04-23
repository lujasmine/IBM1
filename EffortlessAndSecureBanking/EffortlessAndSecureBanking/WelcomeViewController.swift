//
//  WelcomeViewController.swift
//  EffortlessAndSecureBanking
//
//  Created by Jasmine Lu on 21/04/2016.
//  Copyright © 2016 jasminelu. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WelcomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var name: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var longitude:Double!
    var latitude:Double!
    var time:Int!
    var day:Int!
    
    @IBOutlet weak var predLoginLabel: UILabel!
    var predLogin = false
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = defaults.stringForKey("name")
        
        if predLogin {
            predLoginLabel.text = "You Logged in with Prediction Engine!"
        }
        
        if defaults.boolForKey("predio") {
            getProperties()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if !defaults.boolForKey("loggedIn") {
            askToUsePrediction()
            getProperties()
            
            defaults.setBool(true, forKey: "loggedIn")
        }

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let long: Double = location.coordinate.longitude
        let lat: Double = location.coordinate.latitude
        
        longitude = round(long * 10000)/10000
        latitude = round(lat * 10000)/10000
        
        locationManager.stopUpdatingLocation()
        
        //send login event to prediction engine
        Alamofire.request(.GET, "http://esb-php.eu-gb.mybluemix.net/sendEvent.php?time=\(time)&day=\(day)&latitude=\(latitude)&longitude=\(longitude)").response { (req, res, data, error) -> Void in
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(sender: AnyObject) {
        
        defaults.removeObjectForKey("name")
        defaults.removeObjectForKey("fingerprint")
        defaults.removeObjectForKey("loggedIn")
        defaults.removeObjectForKey("phoneNumber")
        defaults.removeObjectForKey("predio")
        defaults.removeObjectForKey("count")
        defaults.synchronize()
        
        let vc = HomeViewController(nibName: nil, bundle: nil)
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func getProperties() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let minute = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
        
        time = (hour*60)+minute
        day = NSCalendar.currentCalendar().component(.Weekday, fromDate:NSDate())
        
    }
    
    func askToUsePrediction() {
        let alertController = UIAlertController(title: "Login Option", message: "Use Prediction Engine for Login?", preferredStyle: .Alert)
        
        let yesOption = UIAlertAction(title: "Yes", style: .Default) {(action) in
            self.defaults.setBool(true, forKey: "predio")
            self.getProperties()
        }
        let noOption = UIAlertAction(title: "No", style: .Default) {(action) in
            self.defaults.setBool(false, forKey: "predio")
        }
        
        alertController.addAction(yesOption)
        alertController.addAction(noOption)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
