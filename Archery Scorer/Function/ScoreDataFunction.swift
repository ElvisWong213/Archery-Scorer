//
//  ScoreDataFunction.swift
//  Archery Scorer
//
//  Created by Elvis on 31/03/2023.
//

import Foundation

class ScoreDataFunction {
    func DefindValue(input: String) -> Int {
        var output = 0
        if input == "M" {
            output = 0
        }else if input == "X" {
            output = 10
        }else if input == "" {
            output = 0
        }else{
            output = Int(input) ?? 0
        }
        return output
    }
    
    func ThreeArrowTotal(scoreDate: [[ScoreData]], i: Int, row: Int) -> Int {
        var range = 0..<3
        var output = 0
        
        if row == 1 {
            range = 3..<6
        }else{
            range = 0..<3
        }
        
        for j in range {
            let dummy = scoreDate[i][j].score!
            output += DefindValue(input: dummy)
        }
        return output
    }
    
    func SixArrowTotal(scoreDate: [[ScoreData]], i: Int) -> Int {
        let range = 0..<6
        var output = 0
        
        for j in range {
            let dummy = scoreDate[i][j].score!
            output += DefindValue(input: dummy)
        }
        return output
    }
    
    func TotalScore(scoreData: [[ScoreData]]) -> Int {
        var output = 0
        for i in scoreData {
            for j in i {
                output += DefindValue(input: j.score! )
            }
        }
        return output
    }
    
    func AverageScore(scoreData: [[ScoreData]], countNilValue: Bool) -> Double {
        var output: Double = 0
        var counter = 0
        for i in scoreData {
            for j in i {
                if countNilValue == false {
                    if j.score != "" {
                        counter += 1
                    }
                }
                if countNilValue == true {
                    counter += 1
                }
                output += Double(DefindValue(input: j.score! ))
            }
        }
        if counter == 0 {
            output = 0
        }else{
            output = output / Double(counter)
        }
        return output
    }
    
    func FindXTimes(scoreData: [[ScoreData]]) -> Int {
        var output = 0
        for i in scoreData {
            for j in i {
                if j.score == "X" {
                    output += 1
                }
            }
        }
        return output
    }
    
    func FlatScoreData(scoreData: [[ScoreData]]) -> [String] {
        var output: [String] = []
        for i in scoreData {
            for j in i {
                output.append(j.score!)
            }
        }
        return output
    }
    
    func AverageScoreEachRound(scoreData: [[ScoreData]]) -> [Double] {
        var output: [Double] = []
        for i in scoreData {
            output.append(AverageScore(scoreData: [i], countNilValue: true))
        }
        return output
    }
    
    func shotsOrRound(scoreData: [[ScoreData]], sorts: Bool) -> Int {
        let newData = FlatScoreData(scoreData: scoreData)
        var counter = 0
        var ans = 0
        for i in newData {
            if i != "" {
                counter += 1
            } else {
                break
            }
        }
        if sorts == true {
            if counter == 36 {
                ans = 6
            } else {
                ans = counter % 6
            }
        } else {
            ans = counter / 6 + 1
            if ans == 7 {
                ans -= 1
            }
        }
        return ans
    }
}
