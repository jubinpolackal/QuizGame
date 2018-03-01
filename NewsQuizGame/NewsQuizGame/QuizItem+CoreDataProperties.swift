//
//  QuizItem+CoreDataProperties.swift
//  NewsQuizGame
//
//  Created by Jubin Jose on 2018-02-24.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//
//

import Foundation
import CoreData


extension QuizItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizItem> {
        return NSFetchRequest<QuizItem>(entityName: "QuizItem")
    }

    @NSManaged public var correctAnswerIndex: Int16
    @NSManaged public var imageURL: String?
    @NSManaged public var section: String?
    @NSManaged public var selectedIndex: Int16
    @NSManaged public var standFirst: String?
    @NSManaged public var storyURL: String?
    @NSManaged public var answerOptions: NSSet?
    @NSManaged public var quiz: QuizMaster?
    
    func createFromDictionary(data: [String:Any?]){
        self.correctAnswerIndex = (data["correctAnswerIndex"] as? Int16)!
        self.imageURL = data["imageUrl"] as? String
        self.standFirst = data["standFirst"] as? String
        self.storyURL = data["storyUrl"] as? String
        self.section = data["section"] as? String
        self.selectedIndex = -1
    }

}

// MARK: Generated accessors for answerOptions
extension QuizItem {

    @objc(addAnswerOptionsObject:)
    @NSManaged public func addToAnswerOptions(_ value: Answers)

    @objc(removeAnswerOptionsObject:)
    @NSManaged public func removeFromAnswerOptions(_ value: Answers)

    @objc(addAnswerOptions:)
    @NSManaged public func addToAnswerOptions(_ values: NSSet)

    @objc(removeAnswerOptions:)
    @NSManaged public func removeFromAnswerOptions(_ values: NSSet)

}
