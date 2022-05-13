//
//  Archery_ScorerApp.swift
//  Archery Scorer
//
//  Created by Steve on 16/3/2022.
//

import SwiftUI

@main
struct Archery_ScorerApp: App {
//    let persistenceController = PersistenceController.shared
    @State private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
//            RecordView(bowData: .constant([58, 150 ,10]), time: .constant(Date.now))
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
