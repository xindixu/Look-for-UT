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
    
    let locationManager = CLLocationManager()
    var lati = 0.0
    var long = 0.0
    var isCorrect = false
    let correctLati = 30.2837284764915
    let correctLong = -97.73958921432495
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Get Ready"
        self.navigationItem.hidesBackButton = true
        
        // check if the location service is available
        if !CLLocationManager.locationServicesEnabled() {
            displayLocationAlert("Error", message: "Location services not turned on!")
        }
        else {
            locationManager.desiredAccuracy = 100 // meters
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
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
                        output.append(username)
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
        
        DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // find user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]
        print("current location: ",currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        self.lati = currentLocation.coordinate.latitude
        self.long = currentLocation.coordinate.longitude
    }
    
    // end of map&location functions

    @IBAction func checkStartingPoint(_ sender: Any) {
        if abs(self.lati - correctLati) < 0.001 && abs(self.long - correctLong) < 0.001 {
            self.isCorrect = true
        }
        else{
            self.isCorrect = false
        }
        print(self.lati)
        print(self.long)
        if self.isCorrect {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "findDestination") as! FindDestinationViewController
            self.present(viewController, animated: true, completion: nil)
        }
        else {
            self.alertStartingPoint(title: "Naughty", message: "Start the game at Littlefield Fountain!")
        }
    }
    
    func alertStartingPoint(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler:{(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if (segue.identifier == "toGame") {
//            let destinationVC = segue.destination as! FindDestinationViewController
//        }
//    }
}
