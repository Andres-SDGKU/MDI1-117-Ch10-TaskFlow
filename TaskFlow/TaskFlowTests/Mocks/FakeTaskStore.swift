//
//  FakeTaskStore.swift
//  TaskFlow
//
//  Created by Andres de la Cruz on 11/5/26.
//

import Foundation
@testable import TaskFlow

class FakeTaskStore: TaskServiceProtocol {
    private(set) var storedTasks: [TaskItem]
    
    init(tasks: [TaskItem] = []) { storedTasks = tasks }
    
    func fetchTasks() -> [TaskItem] {
        storedTasks
    }
    
    func delete(id: UUID) {
        storedTasks.removeAll { $0.id == id }
    }
}
