//
//  ReviewRecordView.swift
//  Archery Scorer
//
//  Created by Steve on 20/3/2022.
//

import SwiftUI
import CoreData

struct ReviewRecordView: View {
    let backgroundColor = Color("BackgroundColor")
    let backgroundColor2 = Color("BackgroundColor2")
    let backgroundColor3 = Color("BackgroundColor3")
    let buttonColor = Color("ButtonColor")
    let textColor = Color("TextColor")
    let cornerRad: CGFloat = 15
    let buttonSize: CGFloat = UIScreen.main.bounds.size.height * 0.04
        
    @EnvironmentObject var startData: StartData
    @EnvironmentObject var appState: BaseViewModel
    @EnvironmentObject var coreDataGameID: CoreDataGameID
    
    let titles = [NSLocalizedString("Lengths: ", comment: ""), NSLocalizedString("Weight: ",comment: ""), NSLocalizedString("Distance: ", comment: "")]
    let units = [NSLocalizedString("inch", comment: ""), NSLocalizedString("lbs", comment: ""), NSLocalizedString("m", comment: "")]
    
    @State var selectedBox = [0, 0]
    @State var selectedRowButton = false
    
    let topItem = [NSLocalizedString("End", comment: ""), "1", "2", "3", "3S", "6S"]
    
    @State var textCollapse = true
    @State private var showPopUp = false
    @State var myImage = UIImage()
       
    var screenshotView: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Distance: ")
                Text(String(startData.distance))
                Text("m")
            }
            .padding(.bottom, 0.1)
            HStack(alignment: .center) {
                Text("Time: ")
                Text(startData.time, format: .dateTime.year().month().day().hour().minute())

            }
            TargetBoard(scoreData: $coreDataGameID.scoreData, selectedBox: $selectedBox, addData: .constant(false), selectedRowButton: $selectedRowButton, scoringMethod: $startData.scoringMethod)
                .foregroundColor(Color.black)
                .disabled(true)
                .frame(width: 350, height: 350)
                .cornerRadius(cornerRad)
                .padding(.vertical)
            HStack {
                Spacer()
                Text("Total: ")
                Text(String(ScoreDataFunction().TotalScore(scoreData: coreDataGameID.scoreData)))
                Spacer()
                Text("Average: ")
                Text("\(ScoreDataFunction().AverageScore(scoreData: coreDataGameID.scoreData, countNilValue: false), specifier: "%.2f")")
                Spacer()
            }
            let boxWidth = UIScreen.main.bounds.width * 0.12
            HStack {
                ForEach(0..<6, id: \.self) { i in
                    if i == 0 {
                        VStack {
                            Text("R")
                                .frame(width: boxWidth, height: boxWidth)
                                .background(buttonColor)
                            Text("S")
                                .frame(width: boxWidth, height: boxWidth)
                                .background(buttonColor)
                        }
                    }
                    VStack {
                        Text(String(i + 1))
                            .frame(width: boxWidth, height: boxWidth)
                            .background(buttonColor)
                        Text(String(ScoreDataFunction().SixArrowTotal(scoreDate: coreDataGameID.scoreData, i: Int(i))))
                            .frame(width: boxWidth, height: boxWidth)
                            .background(buttonColor)
                    }
                }
            }
        }
        .font(.title2)
        .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width * 16 / 9, alignment: .center)
        .background(backgroundColor)
        .foregroundColor(textColor)
    }
        
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        coreDataGameID.edit = true
                        appState.baseView = .record
                    }) {
                        VStack {
                            Text("Edit")
                        }
                        .foregroundColor(buttonColor)
                    }
                    .padding()
                    Spacer()
                    Button {
                        coreDataGameID.edit = false
                        appState.baseView = .home
                    } label: {
                        Text("Done")
                            .foregroundColor(buttonColor)
                    }
                    .padding()
                }
                ScrollView {
                    Button {
                        withAnimation {
                            textCollapse.toggle()
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Show all info")
                            Spacer()
                            Image(systemName: "chevron.up")
                                .transition(.opacity)
                                .rotationEffect(Angle(degrees: textCollapse ? 180 : 0))
                            Spacer()
                        }
                        .padding(.bottom, 0.1)
                        .foregroundColor(buttonColor)
                    }
                    if textCollapse == false {
                        VStack {
                            HStack {
                                Text("Distance: ")
                                Text(String(startData.distance))
                                Text("m")
                            }
                            .padding(.bottom, 0.1)
                            HStack {
                                Text("Time: ")
                                Text(startData.time, format: .dateTime.year().month().day().hour().minute())
                                
                            }
                            .padding(.bottom, 0.1)
                        }
                        .transition(.opacity)
                    }
                    TargetBoard(scoreData: $coreDataGameID.scoreData, selectedBox: $selectedBox, addData: .constant(false), selectedRowButton: $selectedRowButton, scoringMethod: $startData.scoringMethod)
                        .foregroundColor(Color.black)
                        .disabled(true)
                        .frame(width: 350, height: 350)
                        .cornerRadius(cornerRad)
                        .padding()
                    HStack {
                        Spacer()
                        Text("Total: ")
                        Text(String(ScoreDataFunction().TotalScore(scoreData: coreDataGameID.scoreData)))
                        Spacer()
                        Text("Average: ")
                        Text("\(ScoreDataFunction().AverageScore(scoreData: coreDataGameID.scoreData, countNilValue: false), specifier: "%.2f")")
                        Spacer()
                    }
                    .font(.title2)
                    
                    VStack {
                        Text("Score Distribution")
                            .font(.title2)
                        BarChart(scoreData: .constant(ScoreDataFunction().FlatScoreData(scoreData: coreDataGameID.scoreData)), scoringMethod: $startData.scoringMethod)
                            .frame(height: 300)
                            .padding()
                    }
                    .padding(.vertical)
                    .background(backgroundColor2)
                    .cornerRadius(cornerRad)
                    .padding()

                    VStack {
                        Text("Average Score in Each Round")
                            .font(.title2)
                        let score = ScoreDataFunction().AverageScoreEachRound(scoreData: coreDataGameID.scoreData)
                        LineChart(score: .constant(score), circleSize: .constant(CGFloat(8)), color: .constant(textColor), lineWidth: .constant(CGFloat(2)), xAxis: .constant([]))
                            .padding(.vertical)
                            .padding(.horizontal, 30)
                            .frame(height: 300)
                    }
                    .padding(.vertical)
                    .background(backgroundColor2)
                    .cornerRadius(cornerRad)
                    .padding()
                    .padding(.bottom, 20)
                }
                ZStack {
                    backgroundColor
                        .ignoresSafeArea()
                    HStack {
                        Button {
                            showPopUp = true
                            myImage = screenshotView.snapshot()
                        }label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(buttonColor)
                                .font(.system(size: buttonSize))
                                .padding(.horizontal)
                        }
                        .popover(isPresented: $showPopUp) {
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                ExportPopUp(showPopUp: $showPopUp, myImage: $myImage)
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.8)
                            }
                            else if UIDevice.current.userInterfaceIdiom == .phone {
                                ExportPopUp(showPopUp: $showPopUp, myImage: $myImage)
                            }
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.08)
            }
            .foregroundColor(textColor)
        }
    }
}


struct ReviewRecordView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRecordView()
            .environmentObject(CoreDataGameID())
            .environmentObject(StartData())
            .environmentObject(BaseViewModel())
    }
}
