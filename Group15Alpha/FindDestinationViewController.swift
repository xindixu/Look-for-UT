//
//  FindDestinationViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 10/23/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit
import CoreLocation

class FindDestinationViewController: UIViewController,CLLocationManagerDelegate {
    
    var ref: DatabaseReference!
    var gamesRef: DatabaseReference!
    var userRef: DatabaseReference!
    
    var seconds = 3600
    var minutes:Double = 0
    var residual = 0
    var ifTutorial = false
    
    var currentQuestion = 1
    var correctAnswer = ""
    
    var lati = 0.0
    var long = 0.0
    var isCorrect: Bool = false
    
    
    // map stuff
    let locationManager = CLLocationManager()
    var firstTimeSeeMap = true
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var timerL: UILabel!
    @IBOutlet weak var clue: UILabel!
    
    var alertController: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Look For UT"
        
        // set database ref
        ref = Database.database().reference()
        userRef = ref?.child("Players/\((Auth.auth().currentUser?.uid)!)")
        
        if !ifTutorial {
            updateQuestion()
        }
        else{
            self.clue.text = "This is the tutorial, please enter A0"
            self.correctAnswer = "A0"
        }
        runTimer()
        
        // check if the location service is available
        if CLLocationManager.locationServicesEnabled() {
            // Configure the location manager for what we want to track
            locationManager.desiredAccuracy = 100 // meters
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        else {
            self.displayLocationAlert("Error", message: "Location services not turned on!")
        }
        
        firstTimeSeeMap = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateQuestion(){
        // use currentQuestion to get the actual index of the puzzle
        
        // get user info
        _ = self.userRef.observe(.value, with: { (user) in
            
            let value = user.value as! [String:Any]
            let gameCode = value["gameCode"] as! String
            
            // if user is the creator
            if user.hasChild("puzzleCode"){
                self.userRef.child("puzzleCode").observe(.value, with: { (puzzleCode) in
                    // update puzzleIndex / save puzzleIndex to the database
                    let value = puzzleCode.value as! NSArray
                    let currentPuzzleIndex = String(describing: value[self.currentQuestion-1])
                    self.ref?.child("Games/\(gameCode)/currentPuzzle").setValue(currentPuzzleIndex)
                })
            }
            
            // update user interface with appropriate texts
            // creator & member: get info from the database
            self.ref?.child("Games/\(gameCode)/currentPuzzle").observe(.value, with: { currentPuzzle in
                let currentPuzzleIndex = currentPuzzle.value as! String
                
                self.ref?.child("Puzzles/\(currentPuzzleIndex)").observe(.value, with: { snapshot in
                    let value = snapshot.value as! NSDictionary
                    self.clue.text = value["Clue"] as! String
                    let geoPoint = value["GeoPoint"] as! String
                    self.checkPos(geopoint: geoPoint)
                })
            })
        })
    }
    
    
    @IBAction func checkAnswer(_ sender: Any) {
        // change it to "xxx" is equal to "xxx "
        print(self.isCorrect)
        if self.isCorrect {
            createAlert1(title: "You Got This!", message: "Good luck on the next one.")
        }
        else{
            createAlert2(title: "Wrong!", message: "Try again.")
        }
    }
    
    func createAlert1(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{(action) in
            alert.dismiss(animated: true, completion: nil)
            
            // go to next question!!!
            if self.ifTutorial {
                // don't iterate currentQuestion
            } else {
                self.currentQuestion += 1
            }
            
            if(self.currentQuestion == 5){
                // go to a new screen
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "congrats") as? CongratsViewController
                vc!.time = self.seconds
                self.present(vc!, animated: true, completion: nil)
            }
            else{
                self.updateQuestion()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAlert2(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler:{(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func runTimer(){
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector:(#selector(updateTimer)),
                             userInfo:nil,
                             repeats:true)
    }
    
    @objc func updateTimer(){
        self.seconds -= 1
        self.minutes = floor(Double(seconds / 60))
        self.residual = seconds % 60
        self.timerL.text = "Time Left: " + String(format: "%.0f", minutes) + " min " + String(residual) + " sec"
        
    }
    
    // check pos
    
    func checkPos(geopoint:String){
        //30.284043478036256,-97.73692041635513
        //30.289081049140005,-97.740678191185
        var results = geopoint.split(separator: ",")
        let correctLati = Double(results[0])
        let correctLong = Double(results[1])
        
        if abs(self.lati - correctLati!) < 0.001 && abs(self.long - correctLong!) < 0.001 {
            self.isCorrect = true
        }
        else{
            self.isCorrect = false
        }
        print(results)
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
    
    // Called every time our user's location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if firstTimeSeeMap == true {
            print ("first time see map")
            let currentLocation = locations[0]
            let mySpan:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.00)
            print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            self.lati = currentLocation.coordinate.latitude
            self.long = currentLocation.coordinate.longitude
            
            
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            let myRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, mySpan)
            map.setRegion(myRegion, animated: true)
            map.isZoomEnabled = true
            firstTimeSeeMap = false
        }
        
        self.map.showsUserLocation = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // end of map&location functions
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

