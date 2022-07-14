//
//  UUIDToStringUUIDPolicy.swift
//  Archery Scorer
//
//  Created by Elvis on 5/7/2022.
//

import Foundation
import CoreData

final class UUIDToStringUUIDPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let dInstance = NSEntityDescription.insertNewObject(forEntityName: mapping.destinationEntityName!, into: manager.destinationContext)
        dInstance.setValue(sInstance.value(forKey: "average"), forKey: "average")
        dInstance.setValue(sInstance.value(forKey: "distance"), forKey: "distance")
        dInstance.setValue(sInstance.value(forKey: "scoringMethod"), forKey: "scoringMethod")
        dInstance.setValue(sInstance.value(forKey: "time"), forKey: "time")
        dInstance.setValue(sInstance.value(forKey: "total"), forKey: "total")
        let myUUID = sInstance.value(forKey: "uuid") as! UUID
        dInstance.setValue(NSString(string: myUUID.uuidString), forKey: "uuid")
        
        manager.associate(sourceInstance: sInstance, withDestinationInstance: dInstance, for: mapping)
    }
}
