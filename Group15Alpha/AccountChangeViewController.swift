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

class AccountChangeViewController: UIViewController {

    var functionCall:String?
    var ref: DatabaseReference?
    var databaseHandle: DatabaseReference!
    var users: [User] = []
    var settingNumber:Int?
    let currentUser = UILabel(frame: CGRect(x: 100, y: 100, width: 300, height: 30))
    let userChange = UITextField(frame: CGRect(x:100, y:200, width: 300, height: 30))
    let confirmChange = UIButton(frame: CGRect(x: 100, y: 300, width: 300, height: 30))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        promptChange()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    
    func promptChange() {
        let userID = Auth.auth().currentUser?.uid
        ref?.child("Players").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            let username = value?["username"] as? String ?? ""
            self.currentUser.text = username
            self.confirmChange.setTitle("Make Change", for: .normal)
            self.confirmChange.addTarget(self, action: #selector(self.confirmClicked), for: UIControlEvents.touchUpInside)
            self.confirmChange.backgroundColor = .gray
            self.userChange.backgroundColor = .yellow
            
            //Run this setup if change username is selected
            if(self.settingNumber == 0) {
                self.currentUser.text = "Username: \(username)"
                self.view.addSubview(self.currentUser)
                self.view.addSubview(self.userChange)
                self.view.addSubview(self.confirmChange)
            }
            if(self.settingNumber == 2) {
                self.currentUser.text = "Current Email is \(email)"
                self.view.addSubview(self.currentUser)
                self.view.addSubview(self.userChange)
                self.view.addSubview(self.confirmChange)
            }
            
            //Run this setup if change password is selected
            
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    func confirmClicked(sender: UIButton!) {
        let userID = Auth.auth().currentUser?.uid
        let prntRef = Database.database().reference().child("Players").child(userID!);
        print("Make Change is clicked")
            if (self.settingNumber == 0){
                prntRef.updateChildValues(["username": self.userChange.text! as NSString])
            }
            if (self.settingNumber == 2){
                prntRef.updateChildValues(["email": self.userChange.text! as NSString])
            }
        
    
        
        //go back to profile page
        
        //create alert controller for confirmation
        let alertController = UIAlertController(title: "Modification", message: "Change complete.", preferredStyle: UIAlertControllerStyle.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) {action in print("completed")}
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
        
        self.navigationController?.popToRootViewController(animated: true)
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
