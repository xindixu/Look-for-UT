//
//  LoginViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 10/26/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    // Location stuff
    //let locationManager = CLLocationManager()
    
    // Database stuff
    var ref: DatabaseReference!
    var databaseHandle: DatabaseReference!
    var users: [User] = []
    
    @IBOutlet weak var option: UISegmentedControl!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    var alertController: UIAlertController? = nil //what is this alert view for???
    
    @IBAction func switchBetween(_ sender: Any) {
        if self.option.selectedSegmentIndex == 0 {
            // login
            username.alpha = 0
            button.titleLabel?.text = "    Login    "
        }
        else{
            // register
            username.alpha = 1
            button.titleLabel?.text = "Register"
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if authenticated {
            return true
        }
        else{
            return false
        }
    }
    
    var authenticated = false
    
    @IBAction func buttonAction(_ sender: Any) {
        
        if(button.titleLabel?.text == "    Login    "){
            // login
            // print out the login and password
            let userID = Auth.auth().currentUser?.uid

            
//            ref.child("Players").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//                let value = snapshot.value as? NSDictionary
//
//                let email = value?["email"] as? String ?? ""
//                let username = value?["username"] as? String ?? ""
//            }) {(error) in
//                print(error.localizedDescription)
//
//            }
            
            
            if let e = email.text, let p = password.text {
                print("password is \(p)")
                Auth.auth().signIn(withEmail: e, password: p, completion: {(user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        self.createAlert(title: "Error", message: (error?.localizedDescription)!)
                    }
                    else{
                        self.performSegue(withIdentifier: "toMainScreen", sender: self)
                    }
                })
            }
        }
            
        else{
            // register
            if let e = email.text, let p = password.text {
                Auth.auth().createUser(withEmail: e, password: p, completion: { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        self.createAlert(title: "Error", message: (error?.localizedDescription)!)
                    }
                    else{
                        let userID = Auth.auth().currentUser?.uid
                        self.ref?.child("Players").child(userID!).child("username").setValue(self.username.text)
                        self.ref?.child("Players").child(userID!).child("email").setValue(self.email.text)
                        self.performSegue(withIdentifier: "toMainScreen", sender: self)
                    }
                })
            }
        }
    }
    
    func createAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // check if the location service is available
//        if CLLocationManager.locationServicesEnabled() {
//            print("yes")
//            // Configure the location manager for what we want to track.
//            locationManager.desiredAccuracy = 100 // meters
//            locationManager.delegate = self
//            // If user hasn't done so yet, we need to ask for access to the location data.
//            if CLLocationManager.authorizationStatus() == .notDetermined {
//                // Must choose between requesting to get access to location data, either always or only when the app is running.
//                locationManager.requestWhenInUseAuthorization()
//                //locationManager.requestAlwaysAuthorization()
//            }
//        }
//        else {
//            print("no")
//            self.displayAlert("Error", message: "Location Services not available!")
//        }
        
        username.alpha = 0
        
        // set firebase ref
        ref = Database.database().reference()
<<<<<<< HEAD
        print("This is the ref variable \(ref!)")
        
//        // check if the location service is available
//        if CLLocationManager.locationServicesEnabled() {
//            print("yes")
//            // Configure the location manager for what we want to track.
//            locationManager.desiredAccuracy = 100 // meters
//            locationManager.delegate = self
//            // If user hasn't done so yet, we need to ask for access to the location data.
//            if CLLocationManager.authorizationStatus() == .notDetermined {
//                // Must choose between requesting to get access to location data, either always or only when the app is running.
//                locationManager.requestWhenInUseAuthorization()
//                //locationManager.requestAlwaysAuthorization()
//            }
//        }
//        else {
//            print("no")
//            self.displayAlert("Error", message: "Location Services not available!")
//        }
=======
>>>>>>> 7409474a51857e21314de684867b7943badc8f90
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // check if the location service is available
//        if CLLocationManager.locationServicesEnabled() {
//            print("yes")
//            // Configure the location manager for what we want to track.
//            locationManager.desiredAccuracy = 100 // meters
//            locationManager.delegate = self
//            // If user hasn't done so yet, we need to ask for access to the location data.
//            if CLLocationManager.authorizationStatus() == .notDetermined {
//                // Must choose between requesting to get access to location data, either always or only when the app is running.
//                locationManager.requestWhenInUseAuthorization()
//                //locationManager.requestAlwaysAuthorization()
//            }
//        }
//        else {
//            print("no")
//            self.displayAlert("Error", message: "Location Services not available!")
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func displayAlert(_ title:String, message:String) {
//        self.alertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
//        }
//        self.alertController!.addAction(okAction)
//        self.present(self.alertController!, animated: true, completion:nil)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newVC = segue.destination as? MainTabBarController
        newVC?.user = self.user
    }
    */

}
