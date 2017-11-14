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

class LoginViewController: UIViewController {
    var ref: DatabaseReference!
    var databaseHandle: DatabaseReference!
    var users: [User] = []
    
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
            //print out the login and password
            let userID = Auth.auth().currentUser?.uid
            print("UserID is \(userID!)")
            ref.child("Players").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                print("Value is \(value)")
                let username = value?["username"] as? String ?? ""
                print("username is \(username)")
                //let user = User(username: username, dictionary: <#Dictionary<String, Any>#>)
            }) {(error) in
                print(error.localizedDescription)
            }
    
            
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
        username.alpha = 0
        
        // set firebase ref
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
