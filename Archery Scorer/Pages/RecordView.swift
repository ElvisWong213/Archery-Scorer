//
//  RecordView.swift
//  Archery Scorer
//
//  Created by Steve on 17/3/2022.
//

import SwiftUI
import CoreData

struct RecordView: View {
    let backgroundColor = Color("BackgroundColor")
    let backgroundColor2 = Color("BackgroundColor2")
    let buttonColor = Color("ButtonColor")
    let textColor = Color("TextColor")
    
    @EnvironmentObject var startData: StartData
    @EnvironmentObject var appState: BaseViewModel
    @EnvironmentObject var myDate: MyDate
    @EnvironmentObject var coreDataGameID: CoreDataGameID
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var games: FetchedResults<Game>
    
    let topItem = [NSLocalizedString("End", comment: ""), "1", "2", "3", "3S", "6S"]
    let scoreDataFunction = ScoreDataFunction()
    
    @State var disableRowButton = false
    @State var selectedRowButton = false
    
    
    @State var scoreData: [[ScoreData]] = Array(repeating: Array(repeating: ScoreData(score: "", location: CGPoint.init(x: -1, y: -1)), count: 6), count: 6)
    @State var selectedBox = [0, 0]
    
    @State var textCollapse = true
    @State var showAlert = false
        
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        showAlert.toggle()
                    }) {
                        VStack {
                            Text("Cancel")
                                .foregroundColor(buttonColor)
                        }
                    }
                    .padding()
                    .alert("Leave?", isPresented: $showAlert, actions: {
                        Button("Leave", role: .destructive) {
                            coreDataGameID.edit = false
                            appState.baseView = .home
                        }
                        Button("Cancel", role: .cancel) {
                            
                        }
                    }, message: {
                        Text("Data will be lost")
                    })
                    Spacer()
                    Button {
                        let totalScore = scoreDataFunction.TotalScore(scoreData: scoreData)
                        let averageScore = scoreDataFunction.AverageScore(scoreData: scoreData, countNilValue: false)
                        var gameID = UUID().uuidString
                        if coreDataGameID.edit {
                            gameID = coreDataGameID.gameID
                            for game in games {
                                if game.wrappedID == gameID {
                                    moc.delete(game)
                                    try? moc.save()
                                }
                            }
                        }
                        let saveGame = Game(context: moc)
                        saveGame.scoringMethod = startData.scoringMethod
                        saveGame.distance = startData.distance
                        saveGame.average = averageScore
                        saveGame.uuid = gameID
                        saveGame.time = startData.time
                        saveGame.total = Int32(totalScore)
                        var array = [Round(context: moc)]
                        var counter = 0
                        for i in scoreData {
                            for j in i {
                                let dummy = Round(context: moc)
                                dummy.score = j.score
                                dummy.x = j.location!.x
                                dummy.y = j.location!.y
                                dummy.index = Int32(counter)
                                dummy.game = saveGame
                                counter += 1
                                array.append(dummy)
                            }
                        }
                        try? moc.save()
                        
                        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date.now)
                        myDate.year = components.year ?? 2022
                        myDate.month = components.month ?? 2
                        myDate.day = components.day ?? 26
                        
                        coreDataGameID.edit = false
                        
                        appState.baseView = .home
                    } label: {
                        Text("Done")
                            .foregroundColor(buttonColor)
                    }
                    .padding()
                }
                TargetBoard(scoreData: $scoreData, selectedBox: $selectedBox, addData: .constant(true), selectedRowButton: .constant(false), scoringMethod: $startData.scoringMethod)
                    .foregroundColor(Color.black)
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
                if UIDevice.current.userInterfaceIdiom == .phone {
                    ScoreBoard2(scoreData: $scoreData, selectedBox: $selectedBox)
                } else if UIDevice.current.userInterfaceIdiom == .pad {
                    ScoreBoard(scoreData: $scoreData, selectedBox: $selectedBox, disableRowButton: $disableRowButton, selectedRowButton: $selectedRowButton)
                }
                HStack {
                    Spacer()
                    Button {
                        let x = selectedBox[0]
                        let y = selectedBox[1]
                        scoreData[x][y] = ScoreData(score: "", location: CGPoint.init(x: -1, y: -1))
                    } label: {
                        Text("Delete")
                            .frame(width: 80, height: 40)
                            .background(buttonColor)
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .foregroundColor(textColor)
        }
        .onAppear() {
            if coreDataGameID.edit {
                for game in games {
                    if game.wrappedID == coreDataGameID.gameID {
                        var counter_i = 0
                        var counter_j = 0
                        for i in game.roundArray {
                            scoreData[counter_i][counter_j].score = i.wrappedScore
                            scoreData[counter_i][counter_j].location = CGPoint(x: i.x, y: i.y)
                            counter_j += 1
                            if counter_j > 5 {
                                counter_i += 1
                                counter_j = 0
                            }
                        }
                    }
                }
            }
        }
    }
}


struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
//            .environment(\.locale, .init(identifier: "zh-HK"))
        
            .environmentObject(CoreDataGameID())
            .environmentObject(StartData())
            .environmentObject(BaseViewModel())
    }
}
