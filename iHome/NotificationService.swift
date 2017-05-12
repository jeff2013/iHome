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
    
    class func postNotification(withName notification: NotificationType) {
        NotificationService.notificationCenter.post(name: notification.name, object: nil, userInfo: ["message": "Test Message"])
    }
    
    class func addObserver(for name: NSNotification.Name, object: Any?, completion: @escaping (Notification) -> Void) {
        NotificationService.notificationCenter.addObserver(forName: name, object: nil, queue: nil, using: completion)
    }
}
