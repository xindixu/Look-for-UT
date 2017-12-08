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

class LoginViewController: UIViewController,CLLocationManagerDelegate {
    var ref: DatabaseReference!
    var databaseHandle: DatabaseReference!
    var users: [User] = []
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var option: UISegmentedControl!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    var alertController: UIAlertController? = nil
    
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
            
            if let e = email.text, let p = password.text {
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
        self.navigationItem.hidesBackButton = true
        username.alpha = 0
        
        // set firebase ref
        ref = Database.database().reference()
        
        email.autocorrectionType = .no
        password.autocorrectionType = .no
        username.autocorrectionType = .no
        
        // check if the location service is available
        if CLLocationManager.locationServicesEnabled() {
            // Configure the location manager for what we want to track.
            locationManager.desiredAccuracy = 100 // meters
            locationManager.delegate = self
            
            // If user hasn't done so yet, we need to ask for access to the location data.
            if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        else {
            self.displayLocationAlert("Error", message: "Location services not turned on!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // start of map&location functions
    
    func displayLocationAlert(_ title:String, message:String) {
        self.alertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
        }
        self.alertController!.addAction(okAction)
        self.present(self.alertController!, animated: true, completion:nil)
    }
    
    // end of map&location functions

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newVC = segue.destination as? MainTabBarController
        newVC?.user = self.user
    }
    */

}
