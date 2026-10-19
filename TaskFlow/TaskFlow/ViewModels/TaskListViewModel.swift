//
//  TaskListViewModel.swift
//  TaskFlow
//
//  Created by Andres de la Cruz on 9/30/26.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    
    // MARK: Class #1 Functions
    /// Add task function
    func addTask(title: String) {
        guard !title.isEmpty else { return }
        tasks.append(TaskItem(title: title))
    }
    
    /// Delete task function
    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks.remove(at: index)
    }
    
    /// Toggle completion function
    func toggleCompletion(id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].isCompleted.toggle()
    }
    
    /// Completed count text
    var completedCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
}
