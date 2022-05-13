//
//  Round+CoreDataProperties.swift
//  Archery Scorer
//
//  Created by Steve on 22/3/2022.
//
//

import Foundation
import CoreData


extension Round {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Round> {
        return NSFetchRequest<Round>(entityName: "Round")
    }

    @NSManaged public var score: String?
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var index: Int32
    @NSManaged public var game: Game?
        
    public var wrappedScore: String {
        score ?? ""
    }
    
    public var wrappedIndex: Int32 {
        index
    }
}

extension Round : Identifiable {

}
