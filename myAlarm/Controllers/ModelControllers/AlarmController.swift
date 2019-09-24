//
//  AlarmController.swift
//  myAlarm
//
//  Created by Christopher Alegre on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmController: AlarmScheduler {

    static let shared = AlarmController()
    
    var myAlarms: [Alarm] = []
    
    //CRUD
    func addAlarm(fireDate: Date, name: String, enable: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, name: name)
        myAlarms.append(newAlarm)
        saveToPersistantStorage()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enable: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        saveToPersistantStorage()
    }
    
    func delete(alarm: Alarm) {
        guard let alarmDeleted = myAlarms.firstIndex(of: alarm) else {return}
        myAlarms.remove(at: alarmDeleted)
        saveToPersistantStorage()
        cancelUserNotification(for: alarm)
        }
    
    func toggleEnable(alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
        scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotification(for: alarm)
        }
        saveToPersistantStorage()
    }

    
    func createFileForPersistence() -> URL {
        //Grab users document directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //Create new fileURL on users phone
        let fileURL = urls[0].appendingPathComponent("myAlarm.json")
        return fileURL
    }
    
    func saveToPersistantStorage() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonAlarm = try jsonEncoder.encode(myAlarms)
            try jsonAlarm.write(to: createFileForPersistence())
        } catch let error {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    func loadFromPersistantStorage() {
        let jsonDecoder = JSONDecoder()
        
        do {
            let jsonData = try Data(contentsOf: createFileForPersistence())
            let decosedAlarmArray = try jsonDecoder.decode([Alarm].self, from: jsonData)
            myAlarms = decosedAlarmArray
        } catch let error {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
}//End of Class

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotification(for alarm: Alarm)
}

 extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Alarm!"
        notificationContent.body = "Get Going!"
        notificationContent.sound = .default
        
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
        let notificationTigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: notificationTigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func cancelUserNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
    
}

