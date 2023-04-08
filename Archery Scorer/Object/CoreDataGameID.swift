//
//  CoreDataGameID.swift
//  Archery Scorer
//
//  Created by Elvis on 31/03/2023.
//

import Foundation

class CoreDataGameID: ObservableObject {
    @Published var gameID: String = UUID().uuidString
    @Published var edit = false
    @Published var scoreData: [[ScoreData]] = Array(repeating: Array(repeating: ScoreData(score: "", location: CGPoint.init(x: -1, y: -1)), count: 6), count: 6)
}
