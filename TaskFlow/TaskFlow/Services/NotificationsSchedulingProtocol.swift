//
//  NotificationsSchedulingProtocol.swift
//  TaskFlow
//
//  Created by Andres de la Cruz on 11/5/26.
//

protocol NotificationsSchedulingProtocol {
    func scheduleReminder(for task: TaskItem)
}

class NotificationsScheduler: NotificationsSchedulingProtocol {
    func scheduleReminder(for task: TaskItem) {
        // The real implementation goes here
    }
}
