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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let c = generateCode()
        codeL.text! = c
        ref = Database.database().reference()
        ref?.child("Games/\(c)/players").childByAutoId().setValue(Auth.auth().currentUser?.uid)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateCode() -> String{
        let letters:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = letters.count
        var randomString = ""
        for _ in 0...5 {
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
