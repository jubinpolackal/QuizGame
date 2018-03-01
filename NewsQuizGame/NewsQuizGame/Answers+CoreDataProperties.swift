//
//  Answers+CoreDataProperties.swift
//  NewsQuizGame
//
//  Created by Jubin Jose on 2018-02-24.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//
//

import Foundation
import CoreData


extension Answers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answers> {
        return NSFetchRequest<Answers>(entityName: "Answers")
    }

    @NSManaged public var title: String?
    @NSManaged public var quizItem: QuizItem?

}
