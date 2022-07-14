//
//  BarChart.swift
//  Archery Scorer
//
//  Created by Steve on 24/3/2022.
//

import SwiftUI

struct BarChart: View {
    let mark = ["M", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "X"]
    let smallMark = ["M", "6", "7", "8", "9", "10", "X"]
    let markColor = [Color.purple, Color.white, Color.black, Color.blue, Color.red, Color.yellow]
    
    @Binding var scoreData: [String]
    @Binding var scoringMethod: String
    
    var body: some View {
        GeometryReader { gr in
            let numberOfEachScore = findNumberOfEachScore(scoreData: scoreData, scoringMethod: scoringMethod)
            let barHeight = findBarHeight(numberOfEachScore: numberOfEachScore, screenHeight: gr.size.height * 0.8)
            HStack(alignment: .bottom) {
                if scoringMethod == "10" {
                    ForEach ((0...11).reversed(), id: \.self) { i in
                        SubBarView(mark: .constant(mark), numberOfEachScore: .constant(numberOfEachScore), i: .constant(i), scoringMethod: $scoringMethod, barHeight: .constant(barHeight))
                    }
                }
                else if scoringMethod == "6" {
                    ForEach ((0...6).reversed(), id: \.self) { i in
                        SubBarView(mark: .constant(smallMark), numberOfEachScore: .constant(numberOfEachScore), i: .constant(i), scoringMethod: $scoringMethod, barHeight: .constant(barHeight))
                    }
                }
            }
        }
    }
    
    func findNumberOfEachScore(scoreData: [String], scoringMethod: String) -> [Int] {
        var output: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var largeNumber: Int = 1
        var compairArray = mark
        if scoringMethod == "10" {
            largeNumber = mark.count
            compairArray = mark
        }
        else if scoringMethod == "6" {
            largeNumber = smallMark.count
            compairArray = smallMark
        }
        for i in scoreData {
            for j in 0..<largeNumber {
                if i == compairArray[j] {
                    output[j] += 1
                }
            }
        }
        return output
    }
    
    func findBarHeight(numberOfEachScore: [Int], screenHeight: CGFloat) -> [CGFloat] {
        var hightestValue = 0
        var output: [CGFloat] = []
        
        for i in numberOfEachScore {
            if i > hightestValue {
                hightestValue = i
            }
        }
        
        for i in numberOfEachScore {
            var dummy: CGFloat = 0
            if i == 0 {
                dummy = 0
            } else {
                dummy = CGFloat(i) / CGFloat(hightestValue) * screenHeight
            }
            output.append(dummy)
        }
        
        return output
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(scoreData: .constant(ScoreDataFunction().FlatScoreData(scoreData: [[ScoreData]](repeating: [ScoreData](repeating: ScoreData(score: "M", location: CGPoint.init(x: -1, y: -1)), count: 6), count: 6))), scoringMethod: .constant("10"))
//            .frame(height: UIScreen.main.bounds.size.height * 0.7)
    }
}

struct SubBarView: View {
    let markColor = [Color.purple, Color.white, Color.black, Color.blue, Color.red, Color.yellow]
    
    @Binding var mark: [String]
    @Binding var numberOfEachScore: [Int]
    @Binding var i: Int
    @Binding var scoringMethod: String
    @Binding var barHeight: [CGFloat]
    var body: some View {
        VStack {
            Spacer()
            if numberOfEachScore[i] != 0 {
                Text(String(numberOfEachScore[i]))
                    .font(.footnote)
                    .fontWeight(.bold)
            }
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(findColor(i: i, scoringMethod: scoringMethod))
                .frame(height: barHeight[i], alignment: .trailing)
                .transition(AnyTransition.move(edge: .bottom))
            Text(mark[i])
                .fontWeight(.bold)
        }
        .animation(.easeInOut, value: barHeight[i])
    }
    
    func findColor(i: Int, scoringMethod: String) -> Color {
        var output = Color.brown
        if scoringMethod == "10" {
            switch(i) {
            case 0:
                output = markColor[0]
            case 1, 2:
                output = markColor[1]
            case 3, 4:
                output = markColor[2]
            case 5, 6:
                output = markColor[3]
            case 7, 8:
                output = markColor[4]
            case 9, 10, 11:
                output = markColor[5]
            default:
                output = Color.brown
            }
        }
        else if scoringMethod == "6" {
            switch(i) {
            case 0:
                output = markColor[0]
            case 1:
                output = markColor[1]
            case 2:
                output = markColor[2]
            case 3:
                output = markColor[3]
            case 4:
                output = markColor[4]
            case 5, 6:
                output = markColor[5]
            default:
                output = Color.brown
            }
        }
        return output
    }
}
