//
//  WelcomeViewController.swift
//  EffortlessAndSecureBanking
//
//  Created by Jasmine Lu on 21/04/2016.
//  Copyright © 2016 jasminelu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = defaults.stringForKey("name")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
