//
//  ScoreBoard2.swift
//  Archery Scorer
//
//  Created by Steve on 20/3/2022.
//

import SwiftUI

struct ScoreBoard2: View {
    let backgroundColor2 = Color("BackgroundColor2")
    let textColor = Color("TextColor")
    
    @Binding var scoreData: [[ScoreData]]
    @Binding var selectedBox: [Int]
    
    let topItem = [NSLocalizedString("End", comment: ""), "1", "2", "3", "3S", "6S"]
    let scoreDataFunction = ScoreDataFunction()
    
    var body: some View {
        VStack {
            HStack {
                let totalScore = scoreDataFunction.TotalScore(scoreData: scoreData)
                let averageScore = scoreDataFunction.AverageScore(scoreData: scoreData, countNilValue: false)
                let xTimes = scoreDataFunction.FindXTimes(scoreData: scoreData)
                HStack {
                    Text("Total: ")
                    Text("\(totalScore)")
                }
                .frame(maxWidth: .infinity)
                .background(backgroundColor2)
                HStack {
                    Text("Ave: ")
                    Text("\(averageScore, specifier: "%.2f")")
                }
                .frame(maxWidth: .infinity)
                .background(backgroundColor2)
                HStack {
                    Text("X's: ")
                    Text("\(xTimes)")
                }
                .frame(maxWidth: .infinity)
                .background(backgroundColor2)
            }
            .padding([.top, .leading, .trailing])
            TabView(selection: $selectedBox[0]) {
                ForEach(0..<6, id: \.self) { i in
                    VStack {
                        HStack {
                            ForEach(topItem, id: \.self) { item in
                                if (item == "1" || item == "2" || item == "3") {
                                    Text(item)
                                        .frame(width: 50)
                                        .background(backgroundColor2)
                                }else{
                                    Text(item)
                                        .frame(maxWidth: .infinity)
                                        .background(backgroundColor2)
                                }
                            }
                        }
                        .frame(height: 20)
                        HStack {
                            Text(String(i + 1))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(backgroundColor2)
                            ScoreBoardSecondView(scoreData: $scoreData, selectedBox: $selectedBox ,i: .constant(i), selectedRowButton: .constant(false), buttonSize: .constant(50.0))
                            ExtractedView(scoreData: $scoreData, i: .constant(i))
                            let sixArrowScore = scoreDataFunction.SixArrowTotal(scoreDate: scoreData, i: i)
                            Text(String(sixArrowScore))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(backgroundColor2)
                        }
                        .frame(height: 110)
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .padding(.horizontal)
            .transition(.slide)
            .frame(height: 140)

        }
        .foregroundColor(textColor)
    }
}

struct ExtractedView: View {
    let backgroundColor2 = Color("BackgroundColor2")
    
    @Binding var scoreData: [[ScoreData]]
    @Binding var i: Int
    
    let scoreDataFunction = ScoreDataFunction()
    
    var body: some View {
        VStack {
            ForEach(0..<2, id: \.self) { row in
                let threeArrowScore = scoreDataFunction.ThreeArrowTotal(scoreDate: scoreData, i: i, row: row)
                Text(String(threeArrowScore))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(backgroundColor2)
            }
        }
    }
}

struct ScoreBoard2_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoard2(scoreData: .constant([[ScoreData]](repeating: [ScoreData](repeating: ScoreData(score: "", location: CGPoint.init(x: -1, y: -1)), count: 6), count: 6)), selectedBox: .constant([0, 0]))
    }
}
