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

    private var funcNames:[String] = ["Change Username", "Change Password", "Change Email", "Add Name", "Add Gender", "Add Year", "Delete Account"]
    
    var functionCall:String?
    var ref: DatabaseReference?
    var databaseHandle: DatabaseReference!
    var users: [User] = []
    var settingNumber:Int?
    
    @IBOutlet weak var displayInfo: UILabel!
    @IBOutlet weak var userChange: UITextField!
    
    @IBOutlet weak var confirmChangeText: UIButton!
    
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
            
            if(self.settingNumber == 3){
                self.displayInfo.text = "Add your Name"
            }
            
            if(self.settingNumber == 4){
                self.displayInfo.text = "Add your Gender"
                let items = ["Male", "Female", "Fabulous"]
                let segmentedVC = UISegmentedControl(items: ["Male", "Female", "Fabulous"])
                segmentedVC.frame = CGRect(x: 50, y: 200, width: 300, height: 30)
                segmentedVC.selectedSegmentIndex = 0
                self.userChange.isHidden = true
                segmentedVC.addTarget(self, action: "segmentedControlValueChanged:", for:.touchUpInside)
                self.view.addSubview(segmentedVC)
                self.userChange.frame.origin = CGPoint(x:-500, y: -100)
                self.userChange.text = items[segmentedVC.selectedSegmentIndex]
            }
            
            if(self.settingNumber == 5){
                self.displayInfo.text = "Add your Year"
                self.userChange.isHidden = true
            }
            
            if(self.settingNumber == 6) {
                self.displayInfo.text = "Delete Account"
                self.confirmChangeText.setTitle("Click here to delete account", for: .normal)
                self.confirmChangeText.backgroundColor = .red
                self.userChange.isHidden = true
                //Alert Controller Warning for Deletetion
                let alertController = UIAlertController(title: "WARNING", message: "Are you sure you want to delete Account? You will not be able to retrieve this data again", preferredStyle: UIAlertControllerStyle.alert)
                
                let CancelAction = UIAlertAction(title: "Cancel", style: .default) {action in self.navigationController?.popToRootViewController(animated: true)}
                alertController.addAction(CancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) {action in print("cp")}
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true)
            }
            
            //Display subviews
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func confirmChange(_ sender: Any) {
    
    
    //func confirmClicked(sender: UIButton!) {
        let userID = Auth.auth().currentUser?.uid
        let prntRef = Database.database().reference().child("Players").child(userID!);
        print("Make Change is clicked \(self.settingNumber!)")
            if (self.settingNumber == 0){
                prntRef.updateChildValues(["username": self.userChange.text! as NSString])
            }
        
            if (self.settingNumber == 1){
                print("\(self.userChange.text!) is password")
                Auth.auth().currentUser?.updatePassword(to: userChange.text!) { (error) in
                }
            }
 
            if (self.settingNumber == 2){
                Auth.auth().currentUser?.updateEmail(to: userChange.text!) { (error) in
                }
                prntRef.updateChildValues(["email": self.userChange.text! as NSString])
            }
       
            if (self.settingNumber == 3){
                prntRef.child("Name").setValue(self.userChange.text)
            }
  
            if (self.settingNumber == 4){
                prntRef.child("Gender").setValue(self.userChange.text)
            }
    
            if (self.settingNumber == 5){
                prntRef.child("Year").setValue(self.userChange.text)
            }

            if (self.settingNumber == 6){
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
