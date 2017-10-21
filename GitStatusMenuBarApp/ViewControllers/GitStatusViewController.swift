//
//  GitStatusViewController.swift
//  GitStatusMenuBarApp
//
//  Created by Thomas Prezioso on 10/8/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import Cocoa
import Alamofire

class GitStatusViewController: NSViewController {
    @IBOutlet var statusLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        api()
    }

    // MARK: - Convert date methods
    
    func takeStringFromBeginning(stringToCut:String ,start: Int, end: Int) -> String {
        let startIndex = stringToCut.index(stringToCut.startIndex, offsetBy: start)
        let endIndex = stringToCut.index(stringToCut.startIndex, offsetBy: end)
        
        return String(stringToCut[startIndex...endIndex])
    }
    
    func getDateFromJSONDate(dateString: String) -> String {
        let day = takeStringFromBeginning(stringToCut: dateString, start: 8, end: 9)
        let month = takeStringFromBeginning(stringToCut: dateString, start: 5, end: 6)
        let year = takeStringFromBeginning(stringToCut: dateString, start: 0, end: 3)
        
        return "Last Updated\n\(month)/\(day)/\(year)"
    }

    // Mark: - API call
    
    func api() {
//        let hud = BXHUD.showProgress("Loading")
//        self.view.addSubview(hud)
        Alamofire.request("https://status.github.com/api/status.json").responseJSON { response in
//            self.view.addSubview(hud)
            if let JSON = response.result.value {
                let data = JSON as? [String: Any]
                let status = data?["status"] as! String?
                let date = data?["last_updated"] as! String?
                print("\(data!)")
                let dateChangedToStanderedTime = self.getDateFromJSONDate(dateString: date!)
                print("\(dateChangedToStanderedTime)")
                print("\(date!)")
                print("\(status!)")
                
                self.statusLabel.stringValue = "\(dateChangedToStanderedTime) \n Status: \(status!.capitalizingFirstLetter())"
//                self.setBackGroundColorForStatus(status: status!)
//                self.lastUpdatedLabel.text = self.getDateFromJSONDate(dateString: date!)
//                hud.hide(afterDelay: 0.5)
            }
        }
    }
}

extension GitStatusViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> GitStatusViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "GitStatusViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? GitStatusViewController else {
            fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
