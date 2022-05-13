//
//  ContentView.swift
//  Archery Scorer
//
//  Created by Steve on 19/3/2022.
//

import SwiftUI

struct ContentView: View {
    @State var bottomBarButton = [true, false, false]
    @State var startButton = false
    
    @StateObject var startData = StartData()
    @StateObject var appState = BaseViewModel()
    @StateObject var coreDataGameId = CoreDataGameID()
    @StateObject var myDate = MyDate()
    
    var body: some View {
        Group {
            switch appState.baseView {
                case .home:
                    HomeView()
                    .environmentObject(coreDataGameId)
                    .environmentObject(startData)
                    .environmentObject(myDate)
                    .environmentObject(appState)
                case .add:
                    AddView()
                    .environmentObject(startData)
                    .environmentObject(appState)
                case .record:
                    RecordView()
                    .environmentObject(coreDataGameId)
                    .environmentObject(startData)
                    .environmentObject(myDate)
                    .environmentObject(appState)
                case .review:
                    ReviewRecordView()
                    .environmentObject(coreDataGameId)
                    .environmentObject(startData)
                    .environmentObject(appState)
                case .statistic:
                    StatisticsView()
                    .environmentObject(myDate)
                    .environmentObject(appState)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}
