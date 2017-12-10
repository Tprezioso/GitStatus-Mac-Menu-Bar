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
        func showNotification() -> Void {
            let notification = NSUserNotification()
            notification.title = "Test."
            notification.subtitle = "Sub Test."
            notification.soundName = NSUserNotificationDefaultSoundName
//            NSUserNotificationCenter.default.delegate = self
            NSUserNotificationCenter.default.deliver(notification)
        }
}

