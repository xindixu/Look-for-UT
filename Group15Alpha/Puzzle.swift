//
//  Puzzle.swift
//  Group15Alpha
//
//  Created by Xindi Xu on 11/15/17.
//  Copyright © 2017 Group15. All rights reserved.
//

import Foundation

class Puzzle {
    
    var clue: String?
    var answer: String?
    var geoPoint: String?
    
    init(clue:String, answer:String, geoPoint: String) {
        self.clue = clue
        self.answer = answer
        self.geoPoint = geoPoint
    }
}
