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
    
    class func getContracts(completion: @escaping ([String]) -> Void) {
        Alamofire.request("https://status.github.com/api/status.json").responseJSON(completionHandler: {response -> Void in
            
            switch response.result {
                
            case .success(let value):
                var gitStatusData = [String]()
                
                if let JSON = response.result.value {
                    let data = JSON as? [String: Any]
                    let statusFromData = data?["status"] as! String?
                    let dateFromData = data?["last_updated"] as! String?
//                    print("\(dateFromData!)")
//                    print("\(statusFromData!)")
                    gitStatusData.append(statusFromData!)
                    gitStatusData.append(dateFromData!)
                }
//                let json = response.result.value
//                var contracts = [String]()
//                for data in json["data"].arrayValue {
//                    let contract = Contract(json: data)
//                    contracts.append(contract)
//                }
                completion(gitStatusData)
                
            case .failure(let error):
                print(error)
                completion(["fuck"])
            }
        })
    }
//    func api() -> String {
//        var love = ""
//
//        Alamofire.request("https://status.github.com/api/status.json").responseJSON { response in
//            if let JSON = response.result.value {
//                let data = JSON as? [String: Any]
//                let statusFromData = data?["status"] as! String?
//                let dateFromData = data?["last_updated"] as! String?
//                print("\(dateFromData!)")
//                print("\(statusFromData!)")
//                love = statusFromData!
//            }
//        }
//        return love
//    }
}
