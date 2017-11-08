//
//  LoginViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 10/26/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

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
            if let e = email.text, let p = password.text {
                Auth.auth().signIn(withEmail: e, password: p, completion: {(user, error) in
                    if let firebaseError = error {
                        print(firebaseError.localizedDescription)
                        return
                    }
                    print("success!")
                    //self.authenticated = true
                    self.performSegue(withIdentifier: "toMainScreen", sender: self)
                })
            }
        }
            /*
             var authenticed = false
             for item in users{
             if(email.text == item.email && password.text == item.password){
             authenticed = true
             break
             }
             }
             
             // login
             if email.text! == "admin" && password.text! == "admin" {
             // find user with email
             // send user to the new vc
             performSegue(withIdentifier: "toMainScreen", sender: self)
             }
             else if authenticed{
             performSegue(withIdentifier: "toMainScreen", sender: self)
             }
             else{
             createAlert(title: "Error", message: "Wrong email & password combination.")
             }
             */
        else{
            /*
             // create new user
             users.append(User(email:(email?.text)!,password:(password?.text)!))
             */
            if let e = email.text, let p = password.text {
                Auth.auth().createUser(withEmail: e, password: p, completion: { (user, error) in
                    if let firebaseError = error{
                        print(firebaseError.localizedDescription)
                        return
                    }
                    print("success!")
                    //self.authenticated = true
                    self.performSegue(withIdentifier: "toMainScreen", sender: self)
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
        // Do any additional setup after loading the view.
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
