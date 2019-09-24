//
//  Alarm.swift
//  myAlarm
//
//  Created by Christopher Alegre on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit


class Alarm: Codable {
    
    var fireDate: Date
    var name: String
    var enabled: Bool
    let uuid: String
    
    var fireTimeAsString: String {
        let dateFormatters = DateFormatter()
        dateFormatters.dateStyle = .none
        dateFormatters.timeStyle = .short
        let stringOfTime = dateFormatters.string(from: fireDate)
        return stringOfTime
    }

    
    init(fireDate: Date, name: String, enabled: Bool = true, uuid: String = UUID().uuidString) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
    
    
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.fireDate == rhs.fireDate &&
            lhs.name == rhs.name &&
            lhs.enabled == rhs.enabled &&
            lhs.uuid == rhs.uuid
    }
}
