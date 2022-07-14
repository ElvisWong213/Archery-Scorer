//
//  DataController.swift
//  Archery Scorer
//
//  Created by Steve on 22/3/2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentCloudKitContainer(name: "Archery_Scorer")
    
    static var preview: DataController = {
        let result = DataController()
        let viewContext = result.container.viewContext
//        for _ in 0..<5 {
        let newItem = Round(context: viewContext)
        newItem.score = "M"
        newItem.x = 0.0
        newItem.y = 0.0
        newItem.index = 1
        newItem.game = Game(context: viewContext)
        newItem.game?.scoringMethod = "6"
        newItem.game?.distance = "10"
        newItem.game?.average = 10.0
        newItem.game?.uuid = UUID().uuidString
        newItem.game?.time = Date()
        newItem.game?.total = 10
//        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
