//
//  CoreDataManager.swift
//  NewsQuizGame
//
//  Created by Jubin Jose on 2018-02-24.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    
    var managedObjectContext:NSManagedObjectContext?
    
    fileprivate override init() {
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NewsQuizGame")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Public methods
    
    public func saveQuizContent(from:URL){
        self.managedObjectContext = self.persistentContainer.viewContext
        do {
            let quizData = try? Data(contentsOf: from)
            if let quizData = quizData{
                let json = try JSONSerialization.jsonObject(with: quizData, options: []) as? [String: Any]
                if let json = json{
                    self.saveQuiz(json: json)
                }
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    //Reset game and play again
    public func resetQuiz(id:Int64){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizMaster")
        let predicate = NSPredicate(format: "id == %ld", id)
        fetchRequest.predicate = predicate
        do{
            let res = try self.managedObjectContext?.fetch(fetchRequest)
            if let res = res{
                if res.count > 0 {
                    let quiz = res[0] as? QuizMaster
                    quiz?.isCompleted = false
                    quiz?.pointsAcquired = 0
                    self.saveContext()
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    public func getAllQuizes() -> [QuizMaster]?{
        self.managedObjectContext = self.persistentContainer.viewContext
        var quizes:[QuizMaster]?
        let quizFetch = NSFetchRequest<QuizMaster>(entityName: "QuizMaster")
        do {
            quizes = try self.managedObjectContext?.fetch(quizFetch)
        }catch{
            debugPrint(error.localizedDescription)
        }
        return quizes
    }
    
    public func getNextQuizItem(quizId: Int64) -> QuizItem?{
        var theItem:QuizItem?
        
        let fetchRequest = NSFetchRequest<QuizItem>(entityName: "QuizItem")
        let predicate = NSPredicate(format: "(quiz.id = %ld) AND (selectedIndex < 0)", quizId)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        self.managedObjectContext = self.persistentContainer.viewContext
        var quizItems: [QuizItem]?
        do {
            quizItems = try self.managedObjectContext?.fetch(fetchRequest)
            theItem = quizItems?.first
        }catch{
            debugPrint(error.localizedDescription)
        }
        
        return theItem
    }
    
    // MARK: - Private methods
    
    fileprivate func saveQuiz(json:[String: Any?]){
        let id = json["id"] as? Int64
        
        //Check if quiz already exists or not
        var quizExists = false
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizMaster")
        let predicate = NSPredicate(format: "id == %ld", id!)
        fetchRequest.predicate = predicate
        
        do{
            let res = try self.managedObjectContext?.fetch(fetchRequest)
            if let res = res{
                if res.count > 0 {
                    quizExists = true
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        if false == quizExists{
            let quizEntity = NSEntityDescription.entity(forEntityName: "QuizMaster", in: self.managedObjectContext!)
            let quizObj = QuizMaster(entity: quizEntity!, insertInto: self.managedObjectContext)
            
            quizObj.createFromDictionary(data: json)

            let quizListObject = json["items"] as? [[String:Any?]]
            if let quizListObject = quizListObject{
                for quizItem in quizListObject {
                    let quizItemEntity = NSEntityDescription.entity(forEntityName: "QuizItem", in: self.managedObjectContext!)
                    let quizObject = QuizItem(entity: quizItemEntity!, insertInto: self.managedObjectContext!)
                    quizObject.createFromDictionary(data: quizItem)
                    quizObj.addToQuizes(quizObject)
                    
                    let headLinesObject = quizItem["headlines"] as? [String]
                    if let headLinesObject = headLinesObject{
                        for headLine in headLinesObject{
                            let headLineEntity = NSEntityDescription.entity(forEntityName: "Answers", in: self.managedObjectContext!)
                            let headLineObj = Answers(entity: headLineEntity!, insertInto: self.managedObjectContext!)
                            headLineObj.title = headLine
                            quizObject.addToAnswerOptions(headLineObj)
                        }
                    }
                }
            }
            self.saveContext()
            
            NotificationCenter.default.post(name: NSNotification.Name(Constants.syncComplete), object: nil)
        }
    }
}
