//
//  GitStatusViewController.swift
//  GitStatusMenuBarApp
//
//  Created by Thomas Prezioso on 10/8/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import Cocoa

class GitStatusViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
