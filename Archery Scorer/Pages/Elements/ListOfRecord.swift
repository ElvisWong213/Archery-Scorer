//
//  ListOfRecord.swift
//  Archery Scorer
//
//  Created by Steve on 16/3/2022.
//

import SwiftUI
import CoreData

struct ListOfRecord: View {
    let backgroundColor = Color("BackgroundColor")
    let backgroundColor2 = Color("BackgroundColor2")
    let textColor = Color("TextColor")
    let buttonColor = Color("ButtonColor")
    
    @EnvironmentObject var coreDataGameID: CoreDataGameID
    @EnvironmentObject var startData: StartData
    @EnvironmentObject var appState: BaseViewModel
    @EnvironmentObject var myDate: MyDate
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var games: FetchedResults<Game>
    
    @State var mode: EditMode = .inactive
    @State var confirmDelete = false
    @State var index = IndexSet()

    init(startDate: NSDate, endDate: NSDate) {
        _games = FetchRequest<Game>(sortDescriptors: [SortDescriptor(\.time)], predicate: NSPredicate(format: "(time >= %@) AND (time <= %@)", startDate, endDate))
    }
    
    var myList: some View {
        List {
            ForEach(games) { game in
                let dataTime = game.wrappedTime
                if SelectedDate(dataTime: dataTime, year: myDate.year, month: myDate.month, day: myDate.day) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(game.wrappedTime, format: .dateTime.hour().minute())
                            HStack {
                                Text(game.wrappedDistance)
                                Text("m")
                                Text("|")
                                Text(game.wrappedScoringMethod)
                                Text("Zone")
                            }
                            HStack {
                                Text("Total: ")
                                Text(String(game.wrappedTotal))
                                Text("Average: ")
                                Text("\(game.wrappedAverage, specifier: "%.2f")")
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(.title))
                            .foregroundColor(buttonColor)
                    }
                    .listRowBackground(backgroundColor2)
                    .padding()
                    .foregroundColor(textColor)
                    .background(backgroundColor)
                    .cornerRadius(15)
                    .onTapGesture {
                        startData.time = game.wrappedTime
                        startData.distance = game.wrappedDistance
                        startData.scoringMethod = game.wrappedScoringMethod
                        var counter_i = 0
                        var counter_j = 0
                        for i in game.roundArray {
                            coreDataGameID.scoreData[counter_i][counter_j].score = i.wrappedScore
                            coreDataGameID.scoreData[counter_i][counter_j].location = CGPoint(x: i.x, y: i.y)
                            counter_j += 1
                            if counter_j > 5 {
                                counter_i += 1
                                counter_j = 0
                            }
                        }
                        coreDataGameID.gameID = game.wrappedID
                        appState.baseView = .review
                    }
                }
            }
            .onDelete { (indexSet) in
                confirmDelete = true
                index = indexSet
            }
            .alert(isPresented:$confirmDelete) {
                Alert(
                    title: Text("Are you sure you want to delete this?"),
                    message: Text("It cannot be undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        removeRecord(at: index)
                    },
                    secondaryButton: .cancel()
                )
            }
            Text("")
                .listRowBackground(backgroundColor2)
        }
        .environment(\.editMode, $mode)
        .background(backgroundColor2)
        .listStyle(.plain)
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            myList
                .scrollContentBackground(.hidden)
        } else if #available(iOS 15.0, *)  {
            myList
        }
    }
    
    func SelectedDate(dataTime: Date, year: Int, month: Int, day: Int) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let dataYear = formatter.string(from: dataTime)
        formatter.dateFormat = "MM"
        let dataMonth = formatter.string(from: dataTime)
        formatter.dateFormat = "dd"
        let dataDay = formatter.string(from: dataTime)
        
        if year == Int(dataYear) && month == Int(dataMonth) && day == Int(dataDay) {
            return true
        }else{
            return false
        }
    }
    
    func removeRecord(at offset: IndexSet) {
        for index in offset {
            let game = games[index]
            moc.delete(game)
            try? moc.save()
        }
    }
}

struct ListOfRecord_Previews: PreviewProvider {
    static var previews: some View {
        ListOfRecord(startDate: Date() as NSDate, endDate: Date() as NSDate)
            .environmentObject(CoreDataGameID())
            .environmentObject(StartData())
            .environmentObject(MyDate())
            .environmentObject(BaseViewModel())
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)

    }
}
