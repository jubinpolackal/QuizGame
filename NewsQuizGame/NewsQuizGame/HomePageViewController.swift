//
//  HomePageViewController.swift
//  NewsQuizGame
//
//  Created by Jubin JoseH on 2018-02-24.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    var quizList: [QuizMaster]?
    
    @IBOutlet weak var messageLabel: UILabel!
    var selectedQuizMasterItem: QuizMaster?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizList = CoreDataManager.shared.getAllQuizes()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomePageViewController.syncFailed),
                                               name: NSNotification.Name(Constants.downloadFailed),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomePageViewController.syncCompleted),
                                               name: NSNotification.Name(Constants.syncComplete),
                                               object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "QuizGameSegue" {
            let destinationViewController = segue.destination as? QuizLaunchViewController
            if let selectedMasterItem = self.selectedQuizMasterItem{
                destinationViewController?.setQuizMasterItem(theItem: selectedMasterItem)
            }
        }
    }
    
    @objc fileprivate func syncFailed(){
        self.messageLabel.text = "Failed download. Please try again later"
    }
    
    @objc fileprivate func syncCompleted(){
        self.listTableView.reloadData()
    }
}

extension HomePageViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCellId") as! QuizListCell
        
        self.configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedQuizMasterItem = self.quizList?[indexPath.row]
        
        let quizItem = CoreDataManager.shared.getNextQuizItem(quizId: (self.selectedQuizMasterItem?.id)!)
        if quizItem != nil{
            self.performSegue(withIdentifier: "QuizGameSegue", sender: self)
        }else{
            let finalResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinalRresultId") as? FinalResultViewController
            self.navigationController?.pushViewController(finalResultViewController!, animated: true)
        }
    }
    
    func configureCell(cell: QuizListCell, indexPath: IndexPath){
        let nameLabel = cell.viewWithTag(1010) as? UILabel
        let theQuiz = self.quizList?[indexPath.row]
        nameLabel?.text = theQuiz?.name
        let image = (theQuiz?.isCompleted) == true ? UIImage(named: "greenTick") : UIImage(named: "red-cross")
        let statusImageView = cell.viewWithTag(1011) as? UIImageView
        statusImageView?.image = image
    }
}
