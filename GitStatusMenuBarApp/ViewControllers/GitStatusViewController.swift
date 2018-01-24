//
//  GitStatusViewController.swift
//  GitStatusMenuBarApp
//
//  Created by Thomas Prezioso on 10/8/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import Cocoa
import Alamofire

    // MARK: - Extension for Menu Bar App
extension GitStatusViewController {

    // MARK: - Storyboard instantiation for popover menu bar app
    static func menuBarViewController() -> GitStatusViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "GitStatusViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? GitStatusViewController else {
            fatalError("Why cant I find GitStatusViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

    // MARK: - ViewController

class GitStatusViewController: NSViewController {
    @IBOutlet var statusLabel: NSTextField!
    var dataFromAPI = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
    }
   
    // MARK: - Convert date methods
    
    func takeStringFromBeginning(stringToCut:String ,start: Int, end: Int) -> String {
        let startIndex = stringToCut.index(stringToCut.startIndex, offsetBy: start)
        let endIndex = stringToCut.index(stringToCut.startIndex, offsetBy: end)
        
        return String(stringToCut[startIndex...endIndex])
    }
    
    func getDateFromJSONData(dateString: String) -> String {
        let day = takeStringFromBeginning(stringToCut: dateString, start: 8, end: 9)
        let month = takeStringFromBeginning(stringToCut: dateString, start: 5, end: 6)
        let year = takeStringFromBeginning(stringToCut: dateString, start: 0, end: 3)
        
        return "Last Status Change\n\(month)/\(day)/\(year)"
    }

    // MARK : - Setup of Display label
    
    func setupDiplayLabel() {
        if self.dataFromAPI[0] == "No Internet" {
            self.statusLabel.stringValue = self.dataFromAPI[0]
        } else {
            let date = self.dataFromAPI[1]
            let status = self.dataFromAPI[0]
            self.statusLabel.stringValue = "\(getDateFromJSONData(dateString: date))\n Current Status: \(status.capitalizingFirstLetter())"
        }
    }

    // MARK: - API call
    
    func apiCall() {
        APICall.getStatus(completion: { data in
            self.dataFromAPI = data
            self.setupDiplayLabel()
        })
    }
    
    // MARK: - Action Button(s)
    
    @IBAction func detailedStatusButton(_ sender: Any) {
        if let url = URL(string: "https://status.github.com/messages"), NSWorkspace.shared.open(url){
            print("opened in default browser")
        }
        // Used to close app once the button is pressed and you a brought to website
        let appdelegate = NSApplication.shared.delegate as! AppDelegate
        appdelegate.closePopover(sender: sender)
    }

    @IBAction func quitAppBiutton(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}

