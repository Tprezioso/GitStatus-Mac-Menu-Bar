//
//  APICall.swift
//  GitStatusMenuBarApp
//
//  Created by Thomas Prezioso on 10/28/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import Cocoa
import Alamofire

class APICall: NSObject {
    
    class func getStatus(completion: @escaping ([String]) -> Void) {
        Alamofire.request("https://status.github.com/api/status.json").responseJSON(completionHandler: {response -> Void in
            switch response.result {
            case .success( _):
                var gitStatusData = [String]()
                if let JSON = response.result.value {
                    let data = JSON as? [String: Any]
                    let statusFromData = data?["status"] as! String?
                    let dateFromData = data?["last_updated"] as! String?
                    gitStatusData.append(statusFromData!)
                    gitStatusData.append(dateFromData!)
                }
                completion(gitStatusData)
                
            case .failure(let error):
                print(error)
                let gitStatusFailure = "No Internet"
                completion([gitStatusFailure])
            }
        })
    }
}
