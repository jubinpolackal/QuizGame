//
//  SyncManager.swift
//  NewsQuizGame
//
//  Created by Jubin Jose on 2018-02-24.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit
import Foundation

class SyncManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    static let shared = SyncManager()
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "NewsQuizSession")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    var downloadTask : URLSessionDownloadTask?
    
    fileprivate override init() {
        
    }

    //Download quiz data
    public func downloadQuizData(url: String){
        let url = URL(string: url)
        
        self.shouldDownloadQuizData(url: url!){ shouldDownload in
            if true == shouldDownload{
                print("Updated content available ... ")
                self.downloadTask?.cancel()
                self.downloadTask = self.urlSession.downloadTask(with: url!)
                self.downloadTask?.resume()
            }else{
                print("No updated content available")
            }
        }
    }
    
    // Check if a new quiz download is required or not
    // Use http head method
    fileprivate func shouldDownloadQuizData(url:URL, completion: @escaping ((_ shouldDownload:Bool)-> ())) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "HEAD"
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, response, error in
            var isModified = false
            if let error = error{
                print("\(error.localizedDescription)")
            }else{
                if let httpResp: HTTPURLResponse = response as? HTTPURLResponse{
                    let lastModifedDate = httpResp.allHeaderFields["Last-Modified"] as? String
                    if let lastModifedDate = lastModifedDate {
                        let modifiedDate = AppController.shared.globalDateFormatter?.date(from: lastModifedDate)
                        let currentLastModifiedDateString = UserDefaults.standard.object(forKey: Constants.lastModifiedDateKey) as? String
                        if let currentLastModifiedDateString = currentLastModifiedDateString{
                            let currentModifiedDate = AppController.shared.globalDateFormatter?.date(from: currentLastModifiedDateString)
                            if currentModifiedDate?.compare(modifiedDate!) == .orderedAscending{
                                isModified = true
                                UserDefaults.standard.set(lastModifedDate, forKey: Constants.lastModifiedDateKey)
                            }
                        }else{
                            isModified = true
                            //UserDefaults.standard.set(lastModifedDate, forKey: Constants.lastModifiedDateKey)
                        }
                    }
                }
            }
            completion(isModified)
        }
        task.resume()
    }
    
    //MARK: - URLSessionDelegate methods
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let backgroundCompletionHandler =
                appDelegate.backgroundCompletionHandler else {
                    return
            }
            backgroundCompletionHandler()
        }
    }
    
    //MARK: - URLSessionDownloadTask Delegate methods
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            let progressPercentage = progress * 100
            debugPrint("Progress \(progressPercentage)%")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("Download finished: \(location)")
        
        let destinationURL = AppController.shared.getContentFilePath()
        let fileManager = FileManager.default
        
        //Remove old file and copy file to documents directory
        try? fileManager.removeItem(at: destinationURL!)
        do{
            try fileManager.copyItem(at: location, to: destinationURL!)
            CoreDataManager.shared.saveQuizContent(from: destinationURL!)
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        debugPrint("Task completed: \(task)")
        if let error = error{
            debugPrint(error.localizedDescription)
            NotificationCenter.default.post(name: NSNotification.Name(Constants.downloadFailed), object: nil)
        }
    }
    
}
