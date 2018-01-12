//
//  HelperFunctions.swift
//  GitStatusMenuBarApp
//
//  Created by Thomas Prezioso on 1/12/18.
//  Copyright © 2018 Thomas Prezioso. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
