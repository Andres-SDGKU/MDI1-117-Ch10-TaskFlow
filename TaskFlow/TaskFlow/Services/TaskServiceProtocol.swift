//
//  TaskServiceProtocol.swift
//  TaskFlow
//
//  Created by Andres de la Cruz on 11/5/26.
//

import Foundation

protocol TaskServiceProtocol {
    func fetchTasks() -> [TaskItem]
    func delete(id: UUID)
}

class TaskService: TaskServiceProtocol {
    /// This is where the real implementation should go
    func fetchTasks() -> [TaskItem] { [] }
    
    func delete(id: UUID) {
        /// Real backend call goes here
    }
}

class StubTaskService: TaskServiceProtocol {
    private let stubbedTasks: [TaskItem]
    
    init(stubbedTasks: [TaskItem] = [
        TaskItem(title: "Task A", priority: .medium),
        TaskItem(title: "Task B", priority: .medium),
        TaskItem(title: "Task C", priority: .medium)
    ]) { self.stubbedTasks = stubbedTasks }
    
    func fetchTasks() -> [TaskItem] {
        stubbedTasks
    }
    
    func delete(id: UUID) {
        /// Stubs don't need a real behavior
    }
}
