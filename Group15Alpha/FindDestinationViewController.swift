//
//  FindDestinationViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 10/23/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FindDestinationViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    var puzzles: [Puzzle] = []
    
    var geoPointList: [String] = ["(0,0)","(0,0)","(0,0)","(0,0)","(0,0)"]
    var clueList: [String] = ["C0","C0","C0","C0","C0"]
    var answerList: [String] = ["A0","A0","A0","A0","A0"]
    
    var seconds = 3600
    var minutes:Double = 0
    var residual = 0
    var ifTutorial = false
    
    var currentQuestion = 0
    var pIndex: [Int]?
    
    @IBOutlet weak var timerL: UILabel!
    @IBOutlet weak var clue: UILabel!
    @IBOutlet weak var geoPoint: UILabel!
    @IBOutlet weak var answer: UITextField!
    
    var alertController: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set database ref
        print("last VC\(pIndex!)")
        ref = Database.database().reference()
        runTimer()
        if !ifTutorial {
            currentQuestion = 0
        }
        print("answerList\(answerList)")
        clue.text = clueList[currentQuestion]
        geoPoint.text = geoPointList[currentQuestion]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkAnswer(_ sender: Any) {
        // change it to "xxx" is equal to "xxx "
        if answerList[currentQuestion] == answer.text {
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
                self.answer.text = ""
                self.clue.text = self.clueList[self.currentQuestion]
                self.geoPoint.text = self.geoPointList[self.currentQuestion]
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
        self.timerL.text = "Time Left: " + String(minutes) + " min " + String(residual) + " sec"
        
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
