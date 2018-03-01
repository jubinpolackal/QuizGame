//
//  QuizManager.swift
//  NewsQuizGame
//
//  Created by Jubin Jose on 2018-02-25.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit

protocol QuizManagerDelegate {
    func didStartQuiz(sender:QuizManager)
    func pointsTicked(at: Int, sender:QuizManager)
    func didAnswer(score:Int, sender:QuizManager)
    func didEnd(score:Int, sender:QuizManager)
}

class QuizManager: NSObject {
    
    var delegate: QuizManagerDelegate?
    
    var quizData: QuizItem?
    
    var totalSocre:Int = 0
    
    var pointsTick:Int?
    
    var countDownTimer: Timer?
    
    var scoreDeductionCounter: Int?
    
    var isWrongAnswerSelected: Bool?
    
    var count = 1
    
    init(quiz:QuizItem){
        super.init()
        self.quizData = quiz
        self.pointsTick = Constants.questionPoints
        self.countDownTimer = nil
        self.scoreDeductionCounter = Constants.questionPoints
        self.isWrongAnswerSelected = false
    }
    
    //MARK: - Public methods
    
    public func selectAnswer(index: Int){
        if let theTimer = self.countDownTimer{
            theTimer.invalidate()
        }
        if let quizData = self.quizData{
            quizData.selectedIndex = Int16(index)
            CoreDataManager.shared.saveContext()
            //Correct Answer
            if index == Int(quizData.correctAnswerIndex){
                if let delegate = self.delegate{
                    var finalScore: Int = self.scoreDeductionCounter!
                    finalScore -= 2
                    finalScore = (finalScore < 0) ? 0: finalScore
                    delegate.didAnswer(score: finalScore, sender: self)
                }
            }else{
                self.isWrongAnswerSelected = true
                if let delegate = delegate{
                    delegate.didEnd(score: 0, sender: self)
                }
            }
        }
    }
    
    public func startQuiz(){
        if let delegate = self.delegate{
            delegate.didStartQuiz(sender: self)
        }
        self.countDownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(QuizManager.trigger),
                                                   userInfo: nil,
                                                   repeats: true)
    }
    
    public func stopQuiz() {
        if let countDownTimer = self.countDownTimer{
            countDownTimer.invalidate()
        }
    }
    
    //MARK: - Private methods
    
    @objc func trigger(){
        if self.count == Constants.questionPoints{
            if let timer = self.countDownTimer{
                timer.invalidate()
            }
            if let delegate = self.delegate{
                delegate.didEnd(score: 0, sender: self)
            }
        }
        if let delegate = self.delegate{
            delegate.pointsTicked(at: self.pointsTick! - self.count, sender: self)
        }
        self.count += 1
        self.scoreDeductionCounter! -= 1
    }
}
