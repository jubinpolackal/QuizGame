//
//  AppController.swift
//  NewsQuizGame
//
//  Created by Jubin Jose on 2018-02-24.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit

class AppController: NSObject {
    static let shared = AppController()
    
    var globalDateFormatter: DateFormatter?
    
    fileprivate override init() {
        globalDateFormatter = DateFormatter()
        globalDateFormatter?.dateFormat = Constants.globalDateFormat
    }

    func setupApplication(){
        SyncManager.shared.downloadQuizData(url: Constants.sourceUrl)
    }
    
    func getContentFilePath() -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fullPath = "file://\(documentsPath.appendingPathComponent(Constants.contentFileName))"
        
        debugPrint(fullPath)
        
        return URL(string: fullPath)
    }
}
