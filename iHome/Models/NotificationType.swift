//
//  NotificationModel.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-08.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation

enum NotificationType: String {
    case defaultN, lights, blinds
    
    var name: NSNotification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
