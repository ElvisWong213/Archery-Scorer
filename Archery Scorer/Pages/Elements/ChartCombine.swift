//
//  ChartCombine.swift
//  Archery Scorer
//
//  Created by Elvis on 1/5/2022.
//

import SwiftUI
import CoreData

struct ChartCombine: View {
    let cornerRad: CGFloat = 15
    let backgroundColor = Color("BackgroundColor")
    let textColor = Color("TextColor")
    
    @FetchRequest var fetchRequest: FetchedResults<Game>
    
    @EnvironmentObject var myDate: MyDate
    
    @State var scoreDataFunction = ScoreDataFunction()
    
    var scoringMethod: String
    var distance: String
    var selectedRange: String
    @State var scoreData: [[ScoreData]] = [[]]
    
    init(startDate: NSDate, endDate: NSDate, scoringMethod: String, distance: String, selectedRange: String) {
        if distance == "All" {
            _fetchRequest = FetchRequest<Game>(sortDescriptors: [SortDescriptor(\.time, order: .forward)], predicate: NSPredicate(format: "(time >= %@) AND (time <= %@) AND (scoringMethod == %@)", startDate, endDate, scoringMethod))
        } else {
            _fetchRequest = FetchRequest<Game>(sortDescriptors: [SortDescriptor(\.time, order: .forward)], predicate: NSPredicate(format: "(time >= %@) AND (time <= %@) AND (scoringMethod == %@) AND (distance == %@)", startDate, endDate, scoringMethod, distance))
        }
        self.scoringMethod = scoringMethod
        self.distance = distance
        self.selectedRange = selectedRange
    }
    
    var body: some View {
        if fetchRequest.count > 0 {
            ScrollView {
                TargetBoard(scoreData: .constant(getData(range: selectedRange)), selectedBox: .constant([0, 0]), addData: .constant(false), selectedRowButton: .constant(false), scoringMethod: .constant(scoringMethod))
                    .foregroundColor(Color.black)
                    .disabled(true)
                    .frame(width: 350, height: 350)
                    .cornerRadius(cornerRad)
                    .padding()
                VStack {
                    Text("Score Distribution")
                        .font(.title2)
                    BarChart(scoreData: .constant(scoreDataFunction.FlatScoreData(scoreData: getData(range: selectedRange))), scoringMethod: .constant(scoringMethod))
                        .frame(height: 300)
                        .padding()
                }
                .padding(.vertical)
                .background(backgroundColor)
                .cornerRadius(cornerRad)
                .padding()
                
                VStack {
                    Text("Average Score")
                        .font(.title2)
                    let score = ScoreDataFunction().AverageScoreEachRound(scoreData: getData(range: selectedRange))
                    LineChart(score: .constant(score), circleSize: .constant(CGFloat(8)), color: .constant(textColor), lineWidth: .constant(CGFloat(2)), xAxis: .constant(getLineChartXAxis(range: selectedRange)))
                        .padding(.vertical)
                        .padding(.horizontal, 30)
                        .frame(height: 300)
                }
                .padding(.vertical)
                .background(backgroundColor)
                .cornerRadius(cornerRad)
                .padding()
            }
        } else {
            Spacer()
            Text("Not Enought Data")
            Spacer()
        }
    }
    
    func getData(range: String) -> [[ScoreData]] {
        var output: [[ScoreData]] = []
        if range == "Day" {
            for i in fetchRequest {
                var dummyArray: [ScoreData] = []
                var dummy: ScoreData = ScoreData(score: "M", location: CGPoint(x: 0, y: 0))
                for j in i.roundArray {
                    dummy.location = CGPoint(x: j.x, y: j.y)
                    dummy.score = j.score
                    dummyArray.append(dummy)
                }
                output.append(dummyArray)
            }
        }
        else if range == "Week" || range == "Month" {
            var dummyArray: [ScoreData] = []
            var dummyDate =  Calendar.current.dateComponents([.year, .month, .day], from: fetchRequest[0].wrappedTime)
            var counter = 0
            for i in fetchRequest {
                if counter > 0 && Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime).day != dummyDate.day {
                    output.append(dummyArray)
                    dummyArray.removeAll()
                    dummyDate = Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime)
                }
                var dummy: ScoreData = ScoreData(score: "M", location: CGPoint(x: 0, y: 0))
                for j in i.roundArray {
                    dummy.location = CGPoint(x: j.x, y: j.y)
                    dummy.score = j.score
                    dummyArray.append(dummy)
                }
                counter += 1
                if counter == fetchRequest.count {
                    output.append(dummyArray)
                    dummyArray.removeAll()
                    dummyDate = Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime)
                }
            }
        }
        else if range == "Year" {
            var dummyArray: [ScoreData] = []
            var dummyDate = Calendar.current.dateComponents([.year, .month, .day], from: fetchRequest[0].wrappedTime)
            var counter = 0
            for i in fetchRequest {
                if Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime).month != dummyDate.month {
                    output.append(dummyArray)
                    dummyArray.removeAll()
                    dummyDate = Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime)
                }
                var dummy: ScoreData = ScoreData(score: "M", location: CGPoint(x: 0, y: 0))
                for j in i.roundArray {
                    dummy.location = CGPoint(x: j.x, y: j.y)
                    dummy.score = j.score
                    dummyArray.append(dummy)
                }
                counter += 1
                if counter == fetchRequest.count {
                    output.append(dummyArray)
                    dummyArray.removeAll()
                    dummyDate = Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime)
                }
            }
        }
        if output.count == 0 {
            output.append([])
        }
        return output
    }
    
    func getLineChartXAxis(range: String) -> [String] {
        var output: [String] = []
        if range == "Week" || range == "Month" {
            var dummyDate =  Calendar.current.dateComponents([.year, .month, .day], from: fetchRequest[0].wrappedTime)
            var counter = 0
            for i in fetchRequest {
                if counter > 0 && Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime).day != dummyDate.day {
                    output.append(String(dummyDate.day ?? -1))
                    dummyDate = Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime)
                }
                counter += 1
                if counter == fetchRequest.count {
                    output.append(String(dummyDate.day ?? -1))
                    dummyDate = Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime)
                }
            }
        }
        else if range == "Year" {
            var dummyDate =  Calendar.current.dateComponents([.year, .month, .day], from: fetchRequest[0].wrappedTime)
            var counter = 0
            for i in fetchRequest {
                if counter > 0 && Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime).day != dummyDate.day {
                    output.append(String(dummyDate.month ?? -1))
                    dummyDate = Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime)
                }
                counter += 1
                if counter == fetchRequest.count {
                    output.append(String(dummyDate.month ?? -1))
                    dummyDate = Calendar.current.dateComponents([.year, .month, .day], from: i.wrappedTime)
                }
            }
        }
        return output
    }
}

struct ChartCombine_Previews: PreviewProvider {
    static var previews: some View {
        ChartCombine(startDate: Date() as NSDate, endDate: Date() as NSDate, scoringMethod: "6", distance: "All", selectedRange: "Day")
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}
