//
//  TargetBoard.swift
//  Archery Scorer
//
//  Created by Steve on 18/3/2022.
//

import SwiftUI

struct TargetBoard: View {
    let background3 = Color("BackgroundColor3")
    let buttonColor = Color("ButtonColor")
    
    @State var location = CGPoint.zero
    @State var showingDot = false
    
    @Binding var scoreData: [[ScoreData]]
    @Binding var selectedBox: [Int]
    @Binding var addData: Bool
    @Binding var selectedRowButton: Bool
    @Binding var scoringMethod: String
        
    func updateDotData() {
        self.showingDot = true
        let xVal = selectedBox[0]
        let yVal = selectedBox[1]
        scoreData[xVal][yVal].location = location
        scoreData[xVal][yVal].score = findScoreInPosition()
        updateSelecteBox()
    }
    
    func updateSelecteBox() {
        if !(selectedBox[0] == 5 && selectedBox[1] == 5) {
            if selectedBox[0] < 6 {
                withAnimation {
                    selectedBox[1] += 1
                }
            }
            if selectedBox[1] >= 6 && selectedBox[0] < 6{
                withAnimation {
                    selectedBox[0] += 1
                    selectedBox[1] = 0
                }
            }
        }
    }
    
    func findScoreInPosition() -> String {
        var Radius:[Double] = [165, 133, 100, 68, 33, 16, -1]
        var mark = ["6", "7", "8", "9", "10", "X"]
        
        if scoringMethod == "6" {
            Radius = [165, 133, 100, 68, 33, 16, -1]
            mark = ["6", "7", "8", "9", "10", "X"]
        }else if scoringMethod == "10" {
            Radius = [165, 149, 133, 115, 100, 83, 68, 50, 33, 20, 10, -1]
            mark = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "X"]
        }
        
        let centerCoordinate: Double = 175
        
        let x = pow(Double(location.x) - centerCoordinate, 2)
        let y = pow(Double(location.y) - centerCoordinate, 2)
        
        let d = sqrt(x + y)
        
        var counter = -1
        var output = ""
        
        for i in 0..<Radius.count {
            if d > Radius[i] {
                counter = i - 1
                break
            }
        }
        
        if counter == -1 {
            output = "M"
        }else{
            output = mark[counter]
        }
        return output
    }
    
    var body: some View {
        ZStack {
            background3
            if scoringMethod == "6" {
                Image("Target")
                    .resizable()
                    .frame(width: 330, height: 330)
            }else if scoringMethod == "10" {
                Image("Target_L")
                    .resizable()
                    .frame(width: 330, height: 330)
            }
            ForEach(0..<scoreData.count, id: \.self) { i in
                ForEach(0..<scoreData[i].count, id: \.self) { j in
                    let pointLocation = scoreData[i][j].location ?? CGPoint(x: -1, y: -1)
                    let selected = CheckBox(selectedBox: selectedBox, i: i, j: j, selectedRowButton: selectedRowButton)
                    if pointLocation.x >= 0 && pointLocation.y >= 0 {
                        if addData {
                            if selectedBox[0] == i {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 8, height: 8)
                                    .position(pointLocation)
                                    .foregroundColor(selected ? buttonColor : Color.black)
//                                    .animation(nil)
                            }
                        }else{
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 8, height: 8)
                                .position(pointLocation)
                                .foregroundColor(Color.black.opacity(0.75))
//                                .animation(nil)
                        }
                    }
                }
            }
                        
        }
        .gesture(DragGesture(minimumDistance: 0).onEnded{ value in
            self.location = value.location
            self.updateDotData()
        })
        .frame(width: 350, height: 350, alignment: .center)
    }
    
    func CheckBox(selectedBox: [Int], i: Int, j: Int, selectedRowButton: Bool) -> Bool {
        if self.selectedRowButton {
            return selectedBox[0] == i
        }else{
             return selectedBox[0] == i && selectedBox[1] == j
        }
    }
}

struct TargetBoard_Previews: PreviewProvider {
    static var previews: some View {
        TargetBoard(scoreData: .constant(
            [[ScoreData]](repeating: [ScoreData](repeating: ScoreData(score: "", location: CGPoint.init(x: 175, y: 175)), count: 6), count: 6)
        ), selectedBox: .constant([0, 0]), addData: .constant(false), selectedRowButton: .constant(false), scoringMethod: .constant("6"))
    }
}
