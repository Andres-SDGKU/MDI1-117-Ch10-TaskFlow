//
//  MockTaskService.swift
//  TaskFlow
//
//  Created by Andres de la Cruz on 11/5/26.
//

import Foundation
@testable import TaskFlow

class MockTaskService: TaskServiceProtocol {
    var deleteCallCount = 0
    private var tasksToReturn: [TaskItem]
    
    init(tasksToReturn: [TaskItem] = []) { self.tasksToReturn = tasksToReturn }
    
    func fetchTasks() -> [TaskItem] {
        tasksToReturn
    }
    
    func delete(id: UUID) {
        deleteCallCount += 1
    }
}
