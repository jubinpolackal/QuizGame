//
//  QuizLaunchViewController.swift
//  NewsQuizGame
//
//  Created by Jubin Jose on 2018-02-25.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit
import SDWebImage

class QuizLaunchViewController: UIViewController {
    
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var optionsTableview: UITableView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var quizImageView: UIImageView!
    
    var quizMasterItem:QuizMaster?
    
    var quizItem:QuizItem?
    
    var answerOptions: [Answers]?
    
    var quizManager: QuizManager?
    
    var currentScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.quizImageView.image = #imageLiteral(resourceName: "placeholder")
        self.showActivityIndicator(shouldShow: true)
        self.prepareForQuiz()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ResultsSegue" {
            if let quizItem = self.quizItem{
                let destinationVC = segue.destination as? ResultViewController
                destinationVC?.setQuizData(data: quizItem, scoreValue: self.currentScore)
            }
        }
    }


    // MARK: - Private methods
    
    fileprivate func prepareForQuiz(){
        self.currentScore = 0
        if let masterItem = self.quizMasterItem{
            self.quizItem = CoreDataManager.shared.getNextQuizItem(quizId: masterItem.id)
            if let headLines = self.quizItem?.answerOptions{
                self.answerOptions = Array(headLines) as? [Answers]
            }
            self.optionsTableview.reloadData()
            self.progressView.progress = 1.0
            if let theItem = self.quizItem{
                self.quizManager = QuizManager(quiz: theItem)
                self.quizManager?.delegate = self
                self.pointsLabel.text = "\(Constants.questionPoints)+ points coming your way !!!"
            }
        }
    }
    
    fileprivate func prepareView(){
        self.title = "Guess the Headline"
        self.quizImageView.image = #imageLiteral(resourceName: "placeholder")
        sectionLabel.text = self.quizItem?.section
        if let imageURL = self.quizItem?.imageURL{
            self.showActivityIndicator(shouldShow: true)
            let theURL = URL(string: imageURL)
            
            let placeHoldeImage = UIImage(named: "placeHolder")
            
            self.quizImageView.sd_setImage(with: theURL,
                                           placeholderImage: placeHoldeImage,
                                           options: SDWebImageOptions.continueInBackground, completed: {
                                            image, error, cache, url in
                                            DispatchQueue.main.async {
                                                self.showActivityIndicator(shouldShow: false)
                                                self.optionsTableview.reloadData()
                                                if let quizManager = self.quizManager{
                                                    quizManager.startQuiz()
                                                }
                                            }
            })
        }
    }
    
    fileprivate func showResults() {
        self.performSegue(withIdentifier: "ResultsSegue", sender: self)
    }
    
    fileprivate func showActivityIndicator(shouldShow: Bool){
        
        if shouldShow{
            self.imageActivityIndicator.isHidden = false
            self.imageActivityIndicator.startAnimating()
        }else{
            self.imageActivityIndicator.stopAnimating()
            self.imageActivityIndicator.isHidden = true
        }
    }
    
    // MARK: - Public methods
    
    public func setQuizMasterItem(theItem: QuizMaster){
        self.quizMasterItem = theItem
    }
}

extension QuizLaunchViewController : QuizManagerDelegate{
    func didStartQuiz(sender:QuizManager){
        debugPrint("Started quiz ...")
    }
    
    func pointsTicked(at: Int, sender:QuizManager){
        self.progressView.progress = Float(Float(at)/Float(Constants.questionPoints))
        self.pointsLabel.text = "\(at) points coming your way !!!"
    }
    
    func didAnswer(score:Int, sender:QuizManager){
        self.quizMasterItem?.pointsAcquired += Int64(score)
        CoreDataManager.shared.saveContext()
        self.currentScore = score
        self.showResults()
    }
    
    func didEnd(score:Int, sender:QuizManager){
        debugPrint("Quiz ended...")
        self.currentScore = score
        if let theData = self.quizItem{
            theData.selectedIndex = 0
            CoreDataManager.shared.saveContext()
        }
        self.showResults()
    }
}


extension QuizLaunchViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answerOptions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerOptionsCellId") as! AnswerOptionsCell
        
        self.configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.quizManager?.selectAnswer(index: indexPath.row)
    }
    
    func configureCell(cell: AnswerOptionsCell, indexPath: IndexPath){
        cell.optionLabel.layer.cornerRadius = 5.0
        if let answerOptions = self.answerOptions{
            let answerOption = answerOptions[indexPath.row]
            cell.optionLabel.text = answerOption.title
        }
    }
}
