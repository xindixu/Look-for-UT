//
//  AccountChangeViewController.swift
//  Group15Alpha
//
//  Created by Ngo, Billy K on 10/31/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AccountChangeViewController: UIViewController, UITextFieldDelegate {

    private var funcNames:[String] = ["Change Username", "Change Password", "Change Email", "Check Records", "Coupons", "Edit Name, Gender, and Year", "Link Accounts", "Delete Account"]
    
    var functionCall:String?
    var ref: DatabaseReference?
    var databaseHandle: DatabaseReference!
    var users: [User] = []
    var settingNumber:Int?
    let displayInfo = UILabel(frame: CGRect(x: 100, y: 100, width: 300, height: 30))
    let userChange = UITextField(frame: CGRect(x:100, y:200, width: 300, height: 30))
    let confirmChange = UIButton(frame: CGRect(x: 100, y: 300, width: 300, height: 30))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.userChange.delegate = self;
        promptChange()
        self.title = self.funcNames[self.settingNumber!]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func promptChange() {
        let userID = Auth.auth().currentUser?.uid
        ref?.child("Players").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            let username = value?["username"] as? String ?? ""
            
            self.confirmChange.setTitle("Make Change", for: .normal)
            self.confirmChange.addTarget(self, action: #selector(self.confirmClicked), for: UIControlEvents.touchUpInside)
            self.confirmChange.backgroundColor = .gray
            self.userChange.backgroundColor = .yellow
            
            //Run this setup if change username is selected
            if(self.settingNumber == 0) {
                self.displayInfo.text = "Username: \(username)"
            }
            
            //Rune this if change password
            if(self.settingNumber == 1) {
                self.displayInfo.text = "Input your new password"
            }
            
            //Run this setup if change email is selected
            if(self.settingNumber == 2) {
                self.displayInfo.text = "Current Email is \(email)"
            }
            
            if(self.settingNumber == 5){
                self.displayInfo.text = "Add your name, Gender, and Year"
            }
            
            if(self.settingNumber == 7) {
                self.displayInfo.text = "Delete Account"
                self.confirmChange.setTitle("Click here to delete account", for: .normal)
                self.confirmChange.backgroundColor = .red
                
                //Alert Controller Warning for Deletetion
                let alertController = UIAlertController(title: "WARNING", message: "Are you sure you want to delete Account? You will not be able to retrieve this data again", preferredStyle: UIAlertControllerStyle.alert)
                
                let CancelAction = UIAlertAction(title: "Cancel", style: .default) {action in self.navigationController?.popToRootViewController(animated: true)}
                alertController.addAction(CancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) {action in print("completed")}
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true)
            }
            
            //Display subviews
            self.view.addSubview(self.displayInfo)
            self.view.addSubview(self.userChange)
            self.view.addSubview(self.confirmChange)
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    func confirmClicked(sender: UIButton!) {
        let userID = Auth.auth().currentUser?.uid
        let prntRef = Database.database().reference().child("Players").child(userID!);
        print("Make Change is clicked \(self.settingNumber!)")
            if (self.settingNumber == 0){
                prntRef.updateChildValues(["username": self.userChange.text! as NSString])
            }
        
            if (self.settingNumber == 1){
                print("\(self.userChange.text!) is password")
                Auth.auth().currentUser?.updatePassword(to: self.userChange.text!) { (error) in
                }
            }
 
            if (self.settingNumber == 2){
                Auth.auth().currentUser?.updateEmail(to: userChange.text!) { (error) in
                }
                prntRef.updateChildValues(["email": self.userChange.text! as NSString])
            }
        
            if (self.settingNumber == 7){
                let user = Auth.auth().currentUser
                user?.delete { error in
                if let error = error {
                    } else {
                    }
                }
                prntRef.removeValue()
            }
        
        //go back to profile page
        
        //create alert controller for confirmation
        let alertController = UIAlertController(title: "Modification", message: "Change complete.", preferredStyle: UIAlertControllerStyle.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) {action in
            self.navigationController?.popToRootViewController(animated: true)
            print("completed")
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
        
        //self.navigationController?.popToRootViewController(animated: true)
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
