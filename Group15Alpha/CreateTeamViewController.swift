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
        self.navigationItem.hidesBackButton = true

        //gameCode = generateCode() as NSString
        //codeL.text! = gameCode as String
        
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
            // puzzle index: 1....15 numOfPuzzle 15
            let randomNum = Int(arc4random_uniform(14)+1)
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
    
    @IBAction func goToGame(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "getReady") as! GamePrepViewController
        viewController.gameCode = self.gameCode as! String
        self.present(viewController, animated: true, completion: nil)
    }
    
}

