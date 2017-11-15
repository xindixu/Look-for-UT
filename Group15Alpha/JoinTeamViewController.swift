//
//  JoinTeamViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 11/13/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class JoinTeamViewController: UIViewController {
    
    @IBOutlet weak var codeTF: UITextField!
    var ref:DatabaseReference?
    let maxNumOfPlayer = 5
    
    @IBAction func joinATeam(_ sender: Any) {
        let c = codeTF.text!.uppercased()
        // no value entered
        if c == "" {
            createAlert(title: "Error", message: "Please enter a code")
        }
        else{
            // get the data under "Games"
            // this is node "Game"
            _ = ref?.child("Games").observeSingleEvent(of:.value, with: {(snapshot) in
                
                // code is valid
                if snapshot.hasChild(c) {
                    print("valid code")
                    
                    let playerRef = self.ref?.child("Games/\(c)/players")
                    // get the data under "Games/<code>/players"
                    _ = playerRef?.observeSingleEvent(of: .value, with: {(players) in
                        
                        // number of people in a team smaller than 5
                        // reject request of joining a team
                        if players.childrenCount < self.maxNumOfPlayer {
                            self.ref?.child("Games/\(c)/players").childByAutoId().setValue(Auth.auth().currentUser?.uid)
                            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "getReady")
                            self.present(viewcontroller!, animated: true, completion: nil)
                        }
                        else{
                            self.createAlert(title: "Error", message: "The team is full")
                        }
                    })
                }
                else{
                    print("invalid code")
                    self.createAlert(title: "Error", message: "Invalid code")
                }
            })
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
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
