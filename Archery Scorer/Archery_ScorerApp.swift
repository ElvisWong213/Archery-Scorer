//
//  Archery_ScorerApp.swift
//  Archery Scorer
//
//  Created by Steve on 16/3/2022.
//

import SwiftUI

@main
struct Archery_ScorerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
