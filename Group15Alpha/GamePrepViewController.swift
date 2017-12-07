//
//  GamePrepViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 11/14/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation

class GamePrepViewController: UIViewController,CLLocationManagerDelegate {
    
    var ref: DatabaseReference?
    var gameCode: String?
    @IBOutlet weak var playerList: UILabel!
    var nameOfMembers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Get Ready"
        self.navigationItem.hidesBackButton = true
        
        // check if the location service is available
        if !CLLocationManager.locationServicesEnabled() {
            displayLocationAlert("Error", message: "Location services not turned on!")
        }
        
        ref = Database.database().reference()
        print("gameprepVC:  \(gameCode!)")
        var output:[String] = []
        let _ = ref?.child("Games/\(gameCode!)/players").observe(.value, with: { (snapshot) in
            let data = snapshot.value as! [String:Any]
            for i in data.values{
                self.ref?.child("Players/\(i)").observe( .value, with: { (snapshot) in
                    let data = snapshot.value as! [String:Any]
                    if let username = data["username"] as? String{
                        //output.append(username)
                        self.playerList.text = "\(self.playerList.text!)\n\(username)"
                    }
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // start of map&location functions
    
    func displayLocationAlert(_ title:String, message:String) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion:nil)
    }
    
    // end of map&location functions
    

}
