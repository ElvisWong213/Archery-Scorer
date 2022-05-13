//
//  Game+CoreDataProperties.swift
//  Archery Scorer
//
//  Created by Steve on 22/3/2022.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var time: Date?
    @NSManaged public var scoringMethod: String?
    @NSManaged public var distance: String?
    @NSManaged public var total: Int32
    @NSManaged public var average: Double
    @NSManaged public var roundData: NSSet?
    
    public var wrappedID: UUID {
        uuid ?? UUID()
    }
    
    public var wrappedTime: Date {
        time ?? Date()
    }
    
    public var wrappedScoringMethod: String {
        scoringMethod ?? ""
    }
    
    public var wrappedDistance: String {
        distance ?? ""
    }
    
    public var wrappedTotal: Int32 {
        total
    }
    
    public var wrappedAverage: Double {
        average
    }
    
    public var roundArray: [Round] {
        let set = roundData as? Set<Round> ?? []
        
        return set.sorted {
            $0.wrappedIndex < $1.wrappedIndex
        }
    }
}

// MARK: Generated accessors for roundData
extension Game {

    @objc(addRoundDataObject:)
    @NSManaged public func addToRoundData(_ value: Round)

    @objc(removeRoundDataObject:)
    @NSManaged public func removeFromRoundData(_ value: Round)

    @objc(addRoundData:)
    @NSManaged public func addToRoundData(_ values: NSSet)

    @objc(removeRoundData:)
    @NSManaged public func removeFromRoundData(_ values: NSSet)

}

extension Game : Identifiable {

}
