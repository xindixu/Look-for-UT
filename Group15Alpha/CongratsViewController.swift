//
//  CongratsViewController.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 10/23/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import UIKit

class CongratsViewController: UIViewController {
    
    var list:[String] = ["No1","No2","No3"]
    var place = 0
    var time: Int = 0
    
    
    @IBOutlet weak var promoCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if 0 < time && time < 100{
            place = 2
        }
        else if 100 < time && time < 200{
            place = 1
        }
        else{
            place = 0
        }
        promoCode.text = list[place]
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
