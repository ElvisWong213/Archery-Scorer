//
//  StartData.swift
//  Archery Scorer
//
//  Created by Elvis on 31/03/2023.
//

import Foundation

class StartData: ObservableObject {
    @Published var time = Date.now
    @Published var distance = ""
    @Published var scoringMethod = "6"
}
