//
//  Notificationhelper.swift
//  GitStatusMenuBarApp
//
//  Created by Thomas Prezioso on 11/14/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import Foundation

class NotificationHelper {
    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    static func showNotification(message: String) {
        let notification = NSUserNotification()
        notification.hasActionButton = true
        notification.otherButtonTitle = "Close"
        notification.actionButtonTitle = "Details"
        notification.title = "GitHub Status"
        notification.subtitle = "\(message)"
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}

