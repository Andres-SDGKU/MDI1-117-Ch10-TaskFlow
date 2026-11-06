//
//  MockNotificationScheduler.swift
//  TaskFlow
//
//  Created by Andres de la Cruz on 11/5/26.
//

import Foundation
@testable import TaskFlow

class MockNotificationScheduler: NotificationsSchedulingProtocol {
    var scheduleCallCount = 0
    var lastScheduleTasks: TaskItem?
    
    func scheduleReminder(for task: TaskItem) {
        scheduleCallCount += 1
        lastScheduleTasks = task
    }
}
