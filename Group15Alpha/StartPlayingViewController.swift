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
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var currentPlayer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.navigationItem.hidesBackButton = true
        ref = Database.database().reference()
        currentPlayer.text = Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
        
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userID = Auth.auth().currentUser?.uid
        ref?.child("Players").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            let username = value?["username"] as? String ?? ""
            self.title = username
        }) {(error) in
            print(error.localizedDescription)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

