//
//  FinalResultViewController.swift
//  NewsQuizGame
//
//  Created by SOBIN JOSEPH on 2018-02-25.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit

class FinalResultViewController: UIViewController {
    
    var score: Int = 0

    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "High Score"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(FinalResultViewController.backToHomePage))
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.messageLabel.text = "Congratulations. You answered all the questions. Your high score is \(self.score)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Public methods
    
    public func setScore(score:Int){
        self.score = score
    }
    
    // MARK: - Private methods
    
    @objc fileprivate func backToHomePage(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
