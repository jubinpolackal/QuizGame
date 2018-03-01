//
//  Constants.swift
//  NewsQuizGame
//
//  Created by Jubin Jose on 2018-02-24.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit

class Constants: NSObject {
    //URL to the testing nodejs server
    static let sourceUrl = "http://192.168.0.106:3000"

    static let lastModifiedDateKey = "Last Modified Key"
    
    static let globalDateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    static let contentFileName = "QuizContent.json"
    
    static let questionPoints = 10
    
    static let syncComplete = "SyncComplete"
    
    static let downloadFailed = "DownloadFailed"
}
