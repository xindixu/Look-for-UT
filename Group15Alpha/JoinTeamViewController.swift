//
//  JoinTeamViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 11/13/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseDatabase

class JoinTeamViewController: UIViewController {
    
    @IBOutlet weak var codeTF: UITextField!
    var ref:DatabaseReference?
    /*
    @IBAction func joinATeam(_ sender: Any) {
        if let myGame = ref?.child("Games").queryEqual(toValue: codeTF.text?.capitalized) {
            print(myGame)
<<<<<<< HEAD
            performSegue(withIdentifier: "toGame", sender: Any?())
=======
            performSegue(withIdentifier: "toGame", sender: Any?)
>>>>>>> ea76ff155d79720db2bd70dfa96db2449e4394a3
        }
        else{
            print("\n\n\n\n!!!Invaild!!!")
        }
        
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
