//
//  NotificationItem.swift
//  myImage
//
//  Created by Damir Kazbekov on 5/7/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import Foundation

struct NotificationItem {
    var title: String
    var deadline: Date
    var UUID: String
    
    init(deadline: Date, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return (Date().compare(self.deadline) == ComparisonResult.orderedDescending) // deadline is earlier than current date
    }
}

