//
//  AppDelegate.swift
//  GitStatusMenuBarApp
//
//  Created by Thomas Prezioso on 10/4/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    let notification = NSUserNotification()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Init Notification Center Delegate
        NSUserNotificationCenter.default.delegate = self
        NotificationHelper.sampleNotification(notification: self.notification)

        // startTimer function right now is for checking for notifications
        startTimer()
        
        // This used to setup menu bar popover
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = GitStatusViewController.freshController()
        
        // Event Monitor is used to close app once you click outside the view
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }

    // MARK - Notification Center
    // Used for notifications. Keep commented for now until we figure how to do background update
//    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
//        print("checking notification response")
//    }

    func showNotification(apiStatus:String) -> Void {
        let notification = NSUserNotification()
        notification.title = "Github Status"
        notification.subtitle = "Status: \(apiStatus)"
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    func fireOffNotification() {
        NotificationHelper.sampleNotification(notification: notification)
    }
    
    var countdownTimer: Timer!
    var totalTime = 10
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    

    @objc func updateTime() {
        
        if totalTime != 0 {
            totalTime -= 1
            print(totalTime)
        } else {
            // endTimer()
            // added to restart check for update
            // This is still not working because it will never be called
            var dataFromAPICall = [String]()
            APICall.getStatus(completion: { data in
                dataFromAPICall = data
                print(dataFromAPICall)
                self.showNotification(apiStatus: dataFromAPICall[0])
            })
            totalTime = 10
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    // Mark: - Used for toggling a popover view for menu bar app
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            
            // Line below is used to refresh the viewcontroller when toggled on and off for api call                            
            popover.contentViewController = GitStatusViewController.freshController()
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GitStatusMenuBarApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}

