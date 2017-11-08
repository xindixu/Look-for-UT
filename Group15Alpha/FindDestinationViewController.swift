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
    
    var questionList: [String] {
        get {
            if ifTutorial {
                return ["Q0"]
            } else {
                return ["1. How’s the water look?",
                        "2. How many steps can you count to the tower?",
                        "3. Free planners at the front desk, have you found them?",
                        "4. Take care of your hurts and financial needs here!",
                        "5. Have you seen the US Post Office on campus?"]
            }
        }
    }
    
    var clueList: [String] {
        get {
            if ifTutorial {
                return ["C0"]
            } else {
                return ["Let’s start out a little easy, This place is commonly known for graduation pictures",
                        "I have a dream, but where though?",
                        "Let’s go eat, I’m hungry (Abbreviations)",
                        "Medical Issues? Me too",
                        "This building’s exterior design is built correctly wrong"]
            }
        }
    }
    
    var answerList: [String] {
        get {
            if ifTutorial {
                return ["A0"]
            } else {
                return ["A1","A2","A3","A4","A5"]
                //return ["littlefield fountain","east mall","sac","ssb","sutton hall"]
            }
        }
     }
    
    
    var seconds = 3600
    var minutes:Double = 0
    var residual = 0
    var ifTutorial = false
    
    //var questionNum = [0,1,2,3,4,5]
    var currentQuestion = 0
    
    @IBOutlet weak var timerL: UILabel!
    @IBOutlet weak var clue: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer: UITextField!
    
    var alertController: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        runTimer()
        
        clue.text = clueList[currentQuestion]
        question.text = questionList[currentQuestion]
        // Do any additional setup after loading the view.
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
            print("hahah")
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
                self.question.text = self.questionList[self.currentQuestion]
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
