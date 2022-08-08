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
    @EnvironmentObject var appState: BaseViewModel
    @StateObject var coreDataGameId = CoreDataGameID()
    @StateObject var myDate = MyDate()
    
    @AppStorage("wlcome") var welcome: Bool = true
    
    var body: some View {
        ZStack {
            if welcome {
                WelcomeView(wellcome: $welcome)
            } else {
                switch appState.baseView {
                    case .home:
                        HomeView()
                        .environmentObject(coreDataGameId)
                        .environmentObject(startData)
                        .environmentObject(myDate)
                        .environmentObject(appState)
                    case .add:
                        AddView()
                        .transition(AnyTransition.move(edge: .bottom))
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
                        .transition(AnyTransition.move(edge: .bottom))
                        .environmentObject(coreDataGameId)
                        .environmentObject(startData)
                        .environmentObject(appState)
                    case .statistic:
                        StatisticsView()
                        .environmentObject(myDate)
                        .environmentObject(appState)
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.baseView == .add || appState.baseView == .review)
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}
