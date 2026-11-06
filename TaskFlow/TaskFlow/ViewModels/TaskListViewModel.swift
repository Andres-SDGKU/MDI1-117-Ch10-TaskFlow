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
    private let service: TaskServiceProtocol
    private let notificationsScheduler: NotificationsSchedulingProtocol
    private let clock: ClockProtocol
    
    init(
        service: TaskServiceProtocol = TaskService(),
        notificationScheduler: NotificationsSchedulingProtocol = NotificationsScheduler(),
        clock: ClockProtocol = SystemClock()
    ) {
        self.service = service
        self.notificationsScheduler = notificationScheduler
        self.clock = clock
    }
    
    // MARK: Class #3 Functions
    func loadTasks() {
        tasks = service.fetchTasks()
    }
    
    func isOverdue(_ task: TaskItem) -> Bool {
        task.isOverdue(now: clock.now())
    }
    
    // MARK: Class #1 Functions
    /// Add task function
    func addTask(title: String, priority: Priority = .medium, dueDate: Date? = nil) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let task = TaskItem(title: trimmed, priority: priority, dueDate: dueDate)
        tasks.append(task)
        if dueDate != nil {
            notificationsScheduler.scheduleReminder(for: task)
        }
    }
    
    /// Delete task function - Modified on Class #3
    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        let removedId = tasks[index].id
        tasks.remove(at: index)
        service.delete(id: removedId)
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
    
    // MARK: Class #2 Functions
    /// Filter tasks by priority
    func tasks(for priority: Priority) -> [TaskItem] {
        tasks.filter { $0.priority == priority }
    }
    
    /// Sorted tasks by priority
    var tasksSortedByPriority: [TaskItem] {
        let order: [Priority] = [.high, .medium, .low]
        
        return tasks.sorted {
            guard let i = order.firstIndex(of: $0.priority),
                  let j = order.firstIndex(of: $1.priority)
                    else { return false }
            return i < j
        }
    }
    
    /// Toggle favorite function
    func toggleFavorite(id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].isFavorite.toggle()
    }
    
    /// Favorite tasks filter
    var favoriteTasks: [TaskItem] {
        tasks.filter { $0.isFavorite }
    }
}
