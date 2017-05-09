//
//  NotificationService.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-08.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation

class NotificationService {
    
    static let notificationCenter = NotificationCenter.default
    
    func createNotification(notification: NotificationModel) {
        NotificationService.notificationCenter.post(name: notification.getNotification(), object: nil, userInfo: ["message": "Test Message"])
    }
    
    func addObserverFor(name: NSNotification.Name, object: Any?, completion: @escaping (Notification) -> Void) {
        NotificationService.notificationCenter.addObserver(forName: name, object: nil, queue: nil, using: completion)
    }
}
