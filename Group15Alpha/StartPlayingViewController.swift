//
//  StartPlayingViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 10/31/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation

class StartPlayingViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var currentPlayer: UILabel!
    
    // Location stuff
    let locationManager = CLLocationManager()
    var alertController: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPlayer.text = Auth.auth().currentUser?.email
        
        // check if the location service is available
        if CLLocationManager.locationServicesEnabled() {
            print("yes")
            // Configure the location manager for what we want to track.
            //locationManager.desiredAccuracy = 100 // meters
            //locationManager.delegate = self
            // If user hasn't done so yet, we need to ask for access to the location data.
            if CLLocationManager.authorizationStatus() == .notDetermined {
                // Must choose between requesting to get access to location data, either always or only when the app is running.
                locationManager.requestWhenInUseAuthorization()
                //locationManager.requestAlwaysAuthorization()
            }
        }
        else {
            print("no")
            self.displayAlert("Error", message: "Location Services not available!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Signout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do{
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func displayAlert(_ title:String, message:String) {
        self.alertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
        }
        self.alertController!.addAction(okAction)
        self.present(self.alertController!, animated: true, completion:nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
