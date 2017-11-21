//
//  GamePrepViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 11/14/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GamePrepViewController: UIViewController {
    
    var ref: DatabaseReference?
    var gameCode: String?
    @IBOutlet weak var playerList: UILabel!
    var players: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print("gameprepVC:  \(gameCode!)")
        ref?.child("Games/\(gameCode!)/players").observe(.childAdded, with: { (players) in
            let value = players.value as! String

            print("hahahah")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
