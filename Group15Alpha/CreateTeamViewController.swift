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
    var pIndex:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let c = generateCode()
        codeL.text! = c
        ref = Database.database().reference()
        ref?.child("Games/\(c)/players").childByAutoId().setValue(Auth.auth().currentUser?.uid)
        
        generatePuzzleIndex()
        ref?.child("Games/\(c)/puzzleIndex").setValue(self.pIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func generateCode() -> String {
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

    
    func generatePuzzleIndex() {
        // add random 5 puzzles
        while self.pIndex.count < 5 {
            print("While is working")
            // range
            // puzzle index: 0....7 numOfPuzzle 8
            let randomNum = Int(arc4random_uniform(7))
            // check if duplicated
            var duplicated = false
            for i in self.pIndex {
                if randomNum == i {
                    duplicated = true
                }
            }
            if !duplicated {
                self.pIndex.append(randomNum)
            }
        }
        print("last\(pIndex)")
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newVC = segue.destination as! GamePrepViewController
        newVC.temp = self.pIndex
    }
    

}
