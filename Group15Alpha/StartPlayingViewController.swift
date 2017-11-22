//
//  StartPlayingViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 10/31/17.
//  Copyright © 2017 Group15. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase

class StartPlayingViewController: UIViewController {
    
    var ref: DatabaseReference?
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var currentPlayer: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        ref = Database.database().reference()
        currentPlayer.text = Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
        displayAccount()
        record.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayAccount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAccount() {
        let userID = Auth.auth().currentUser?.uid
        ref?.child("Players").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            let accUsername = value?["username"] as? String ?? ""
            let accYear = value?["year"] as? String ?? ""
            let accGender = value?["gender"] as? String ?? ""
            
            self.title = accUsername
            self.username.text = "Username : \(accUsername)"
            self.year.text = "Year is \(accYear)"
            self.gender.text = "Gender is \(accGender)"
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

