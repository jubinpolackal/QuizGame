//
//  QuizMaster+CoreDataProperties.swift
//  NewsQuizGame
//
//  Created by Jubin Jose on 2018-02-24.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//
//

import Foundation
import CoreData


extension QuizMaster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizMaster> {
        return NSFetchRequest<QuizMaster>(entityName: "QuizMaster")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var pointsAcquired: Int64
    @NSManaged public var version: Int32
    @NSManaged public var quizes: NSSet?

    func createFromDictionary(data: [String:Any?]){
        self.name = data["product"] as? String
        self.isCompleted = false
        self.pointsAcquired = 0
        self.version = (data["version"] as? Int32)!
        self.id = (data["id"] as? Int64)!
    }
}

// MARK: Generated accessors for quizes
extension QuizMaster {

    @objc(addQuizesObject:)
    @NSManaged public func addToQuizes(_ value: QuizItem)

    @objc(removeQuizesObject:)
    @NSManaged public func removeFromQuizes(_ value: QuizItem)

    @objc(addQuizes:)
    @NSManaged public func addToQuizes(_ values: NSSet)

    @objc(removeQuizes:)
    @NSManaged public func removeFromQuizes(_ values: NSSet)

}
