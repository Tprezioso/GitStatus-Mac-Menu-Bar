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
        notification.actionButtonTitle = "Show"
        notification.title = "Git Status"
        notification.subtitle = ""
        notification.informativeText = "This is a test"
        notificationCenter.deliver(notification)
    }
}
