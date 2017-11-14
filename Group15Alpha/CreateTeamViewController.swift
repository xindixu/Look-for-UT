//
//  CreateTeamViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 11/13/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class CreateTeamViewController: UIViewController {

    @IBOutlet weak var codeL: UILabel!
    var ref: DatabaseReference?
    var handle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeL.text = generateCode()
        ref = Database.database().reference()
        ref?.child("Games").child(codeL.text!).child("players").setValue(Auth.auth().currentUser!.uid)
        
        handle = ref?.child("Games").observe(.value, with: { (snapshot) in
            for child in snapshot.children {
                print(child)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateCode() -> String{
        let letters:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = letters.count
        var randomString = ""
        for _ in 0...6 {
            let randomNum = Int(arc4random_uniform(UInt32(len)))
            let char = letters[letters.index(letters.startIndex, offsetBy: randomNum)]
            randomString.append(char)
        }
        return randomString
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
