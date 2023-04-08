//
//  ScoreData.swift
//  Archery Scorer
//
//  Created by Elvis on 31/03/2023.
//

import Foundation

struct ScoreData {
    var score: String?
    var location: CGPoint?
    
    init (score: String, location: CGPoint) {
        self.score = score
        self.location = location
    }
}
