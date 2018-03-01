//
//  ResultViewController.swift
//  NewsQuizGame
//
//  Created by SOBIN JOSEPH on 2018-02-25.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit
import SDWebImage

class ResultViewController: UIViewController {

    @IBOutlet weak var standFirstLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var storyImageView: UIImageView!
    
    var quizData: QuizItem?
    
    var score: Int?
    
    var articleURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UIControl Actions
    
    @IBAction func readArticleTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "NewsDetailId", sender: self)
    }
    
    @IBAction func nextQuestionTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func leaderBoardAction(_ sender: Any) {
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NewsDetailId" {
            let destinationVC = segue.destination as? ArticleViewController
            if let url = self.quizData?.storyURL{
                destinationVC?.setArticleUrl(theUrl: URL(string: url))
            }
        }
    }


    //MARK: - Public methods
    
    public func setQuizData(data: QuizItem, scoreValue: Int){
        self.quizData = data
        self.score = scoreValue
    }
    
    //MARK: - Private methods
    
    fileprivate func prepareView(){
            if let quizData = self.quizData {
                let imageURL = URL(string: quizData.imageURL!)
                self.storyImageView.sd_setImage(with: imageURL, completed: nil)
                self.standFirstLabel.text = quizData.standFirst!
                self.articleURL = URL(string: quizData.storyURL!)
                
                if let scoreValue = self.score{
                    scoreLabel.text = "You got \(scoreValue) points. Keep going"
                }
                
                self.title = "Result"
        }
    }
}
