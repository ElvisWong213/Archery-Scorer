//
//  ScoreBoard.swift
//  Archery Scorer
//
//  Created by Steve on 20/3/2022.
//

import SwiftUI

struct ScoreBoard: View {
    let backgroundColor2 = Color("BackgroundColor2")
    let textColor = Color("TextColor")
    
    @Binding var scoreData: [[ScoreData]]
    @Binding var selectedBox: [Int]
    @Binding var disableRowButton: Bool
    @Binding var selectedRowButton: Bool
    
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
            .padding(.horizontal)
            ScrollView {
                VStack {
                    ForEach(0..<6, id: \.self) { i in
                        HStack {
                            Button {
                                if selectedBox[0] == i && selectedRowButton {
                                    selectedRowButton = false
                                }else{
                                    selectedRowButton = true
                                }
                                selectedBox[0] = i
                            } label: {
                                Text(String(i + 1))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(backgroundColor2)
                                    .disabled(disableRowButton)
                            }
                            ScoreBoardSecondView(scoreData: $scoreData, selectedBox: $selectedBox ,i: .constant(i), selectedRowButton: $selectedRowButton)
                            threeSScoreView(scoreData: $scoreData, i: .constant(i))
                            let sixArrowScore = scoreDataFunction.SixArrowTotal(scoreDate: scoreData, i: i)
                            Text(String(sixArrowScore))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(backgroundColor2)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .foregroundColor(textColor)
    }
}

struct ScoreBoardSecondView: View {
    let backgroundColor2 = Color("BackgroundColor2")
    let buttonColor = Color("ButtonColor")
    
    @Binding var scoreData: [[ScoreData]]
    @Binding var selectedBox: [Int]
    @Binding var i: Int
    @Binding var selectedRowButton: Bool
    
    var body: some View {
        VStack {
            ForEach(0..<2, id: \.self) { j in
                HStack {
                    ForEach((0..<3), id: \.self) { k in
                        let data = scoreData[i][j * 3 + k]
                        let display = data.score
                        let selected = CheckBox(selectedBox: selectedBox, i: i, j: j, k: k, selectedRowButton: selectedRowButton)
                        Button {
                            selectedBox = [i, j * 3 + k]
                            selectedRowButton = false
                        } label: {
                            Text(display!)
                                .frame(width: 50, height: 50)
                                .background(selected ? buttonColor : backgroundColor2)
                        }
                    }
                }
            }
        }
    }
    
    func CheckBox(selectedBox: [Int], i: Int, j: Int, k: Int, selectedRowButton: Bool) -> Bool {
        if self.selectedRowButton {
            return selectedBox[0] == i
        }else{
             return selectedBox[0] == i && selectedBox[1] == j * 3 + k
        }
    }
}

struct threeSScoreView: View {
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

struct ScoreBoard_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoard(scoreData: .constant([[ScoreData]](repeating: [ScoreData](repeating: ScoreData(score: "", location: CGPoint.init(x: -1, y: -1)), count: 6), count: 6)), selectedBox: .constant([0, 0]), disableRowButton: .constant(false), selectedRowButton: .constant(false))
    }
}
