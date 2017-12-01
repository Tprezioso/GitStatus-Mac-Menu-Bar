//
//  Notificationhelper.swift
//  GitStatusMenuBarApp
//
//  Created by Thomas Prezioso on 11/14/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import Foundation

class NotificationHelper {
    static func sampleNotification(notification: NSUserNotification, status:String) {
        
        let notificationCenter = NSUserNotificationCenter.default
        
        notification.identifier = "unique-id-123"
        notification.hasActionButton = true
        notification.otherButtonTitle = "Close"
        notification.actionButtonTitle = "Details"
        notification.title = "Git Status"
        notification.subtitle = "\(status)"
//        notification.informativeText = "This is a test"
        notificationCenter.deliver(notification)
    }
}
