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
    var gameCode:NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gameCode = generateCode() as NSString
        codeL.text! = gameCode as String
        
        ref = Database.database().reference()
        
        let uid = (Auth.auth().currentUser?.uid)!
        ref?.child("Games/\(gameCode)/players").childByAutoId().setValue(uid)
        
        generatePuzzleIndex()
        ref?.child("Games/\(gameCode)/puzzleIndex").setValue(self.pIndex)
        
        let userID = Auth.auth().currentUser?.uid
        self.ref?.child("Players/\(userID!)/gameCode").setValue(gameCode)
        self.ref?.child("Players/\(userID!)/puzzleCode").setValue(pIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func generateCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = letters.count
        var randomString = ""
        for _ in 0...5 {
            let randomNum = Int(arc4random_uniform(UInt32(len)))
            let char = letters[letters.index(letters.startIndex, offsetBy: randomNum)]
            randomString.append(char)
        }
        return randomString
    }
    */
    
    func generatePuzzleIndex() {
        // add random 5 puzzles
        while self.pIndex.count < 5 {
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
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let newVC = segue.destination as! GamePrepViewController
     newVC.temp = self.pIndex
     }
     */
    
}

