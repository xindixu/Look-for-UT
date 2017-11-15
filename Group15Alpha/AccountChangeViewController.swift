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
        
        
        let currentUser = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 30))
        currentUser.center = CGPoint(x:160, y:200)
        currentUser.text = username
        let promptChange = UITextField(frame: CGRect(x:100, y:200, width: 100, height: 30))
        let confirmChange = UIButton(frame: CGRect(x: 100, y: 300, width: 200, height: 30))
        confirmChange.setTitle("Make Change", for: .normal)
            confirmChange.addTarget(self, action: #selector(self.confirmClicked), for: UIControlEvents.touchUpInside)
        
        
            
            //Run this setup if change username is selected
            if(self.settingNumber == 0) {
                print("value is \(username)")
                currentUser.center = CGPoint(x:160, y:200)
                confirmChange.backgroundColor = .gray
                promptChange.backgroundColor = .blue
                self.view.addSubview(currentUser)
                self.view.addSubview(promptChange)
                self.view.addSubview(confirmChange)
            }
            
            //Run this setup if change password is selected
            
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    func confirmClicked(sender: UIButton!) {
        
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
