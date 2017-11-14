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
    
    // username: 1@utexas.edu, 2@utexas.edu
    // password: 123456
    
    
    @IBOutlet weak var codeTF: UITextField!
    var ref:DatabaseReference?

    var alterController: UIAlertController? = nil
    
    @IBAction func joinATeam(_ sender: Any) {
        let c = codeTF.text!
        print(c)
        let handler = ref?.child("Games").observeSingleEvent(of:.value, with: {(snapshot) in
            if snapshot.hasChild(c) {
                print("valid code")
                self.ref?.child("Games/\(c)/players").childByAutoId().setValue(Auth.auth().currentUser?.uid)
                self.performSegue(withIdentifier: "toGame", sender: self)
            }
            else{
                print("invalid code")
                self.createAlert(title: "Error", message: "Invalid code")
            }
        })
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
