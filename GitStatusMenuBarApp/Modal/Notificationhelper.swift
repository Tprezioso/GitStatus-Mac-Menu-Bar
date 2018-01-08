//
//  Notificationhelper.swift
//  GitStatusMenuBarApp
//
//  Created by Thomas Prezioso on 11/14/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import Foundation

class NotificationHelper {
    static func sampleNotification(notification: NSUserNotification) {
        
        let notificationCenter = NSUserNotificationCenter.default
        
        notification.identifier = "unique-id-123"
        notification.hasActionButton = true
        notification.otherButtonTitle = "Close"
        notification.actionButtonTitle = "Details"
        notification.title = "Git Status"
        notification.subtitle = "hello"
        notification.informativeText = "This is a test"
        notificationCenter.deliver(notification)
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    static func showNotification(message: String) {
        let notification = NSUserNotification()
        notification.hasActionButton = true
        notification.title = "GitHub Status"
        notification.otherButtonTitle = "Close"
        notification.actionButtonTitle = "Details"
        notification.subtitle = "\(message)"
        notification.soundName = NSUserNotificationDefaultSoundName
//            NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(notification)
    }
}

