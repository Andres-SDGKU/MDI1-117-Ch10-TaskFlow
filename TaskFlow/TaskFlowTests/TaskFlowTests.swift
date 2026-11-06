//
//  TaskFlowTests.swift
//  TaskFlowTests
//
//  Created by Andres de la Cruz on 9/30/26.
//

import XCTest
@testable import TaskFlow

final class TaskFlowTests: XCTestCase {

    var viewModel: TaskListViewModel!
    
    override func setUpWithError() throws {
        viewModel = TaskListViewModel()
    }

    /// Exercise #1
    func test_addTask_increasesTaskCount() {
        // Arrange: setUpWithError provides an empty view model
     
        // Act
        viewModel.addTask(title: "Buy groceries")
     
        // Assert
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Buy groceries")
    }
    
    /// Exercise #2
    func test_removeTask_removesCorrectItem() {
        // Arrange
        viewModel.addTask(title: "Task A")
        viewModel.addTask(title: "Task B")
     
        // Act
        viewModel.removeTask(at: 0)
     
        // Assert
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Task B")
    }
    
    
    /// Exercise #3
    func test_toggleCompletion_flipsIsCompleted() {
        // Arrange
        viewModel.addTask(title: "Task A")
        let taskId = viewModel.tasks[0].id
        XCTAssertFalse(viewModel.tasks[0].isCompleted)
        
        // Act
        viewModel.toggleCompletion(id: taskId)
        
        // Assert
        XCTAssertTrue(viewModel.tasks[0].isCompleted)
    }
    
    /// Exercise #4
    func test_addTask_withEmptyTitle_isIgnored() {
        // Arrange
        let initialCount = viewModel.tasks.count
        
        // Act
        viewModel.addTask(title: "     ")
        
        // Assert
        XCTAssertEqual(viewModel.tasks.count, initialCount, "A blank title should not create a task")
    }
    
    // MARK: Class #2
    /// Live demo - Default priority
    func test_addTask_defaultPriorityIsMedium() {
        // Arrange
        
        // Act
        viewModel.addTask(title: "Task A")
        
        // Assert
        XCTAssertEqual(viewModel.tasks[0].priority, .medium)
    }
    
    /// Exercise #1 - Priority on creation
    func test_addTask_withHighPriority_storesPriority() {
        // Arrange
        
        // Act
        viewModel.addTask(title: "Urgent", priority: .high)
        
        // Assert
        XCTAssertEqual(viewModel.tasks[0].priority, .high)
    }
    
    /// Exercise #2 - Filtering by priority
    func test_tasks_forPriority_returnsOnlyMatchingTasks() {
        // Arrange
        viewModel.addTask(title: "Low", priority: .low)
        viewModel.addTask(title: "High 1", priority: .high)
        viewModel.addTask(title: "High 2", priority: .high)
        
        // Act
        let highTasks = viewModel.tasks(for: .high)
        
        // Assert
        XCTAssertEqual(highTasks.count, 2)
        XCTAssert(highTasks.allSatisfy { $0.priority == .high })
    }
    
    /// Exercise #3 - Sorting by priority
    func test_taskSortedByPriority_returnsHighFirst() {
        // Arrange
        viewModel.addTask(title: "Low", priority: .low)
        viewModel.addTask(title: "Medium", priority: .medium)
        viewModel.addTask(title: "High", priority: .high)
        
        // Act
        let sorted = viewModel.tasksSortedByPriority
        
        // Assert
        XCTAssertEqual(sorted[0].priority, .high)
        XCTAssertEqual(sorted[1].priority, .medium)
        XCTAssertEqual(sorted[2].priority, .low)
    }
    
    /// Exercise #4 - Favorite by default
    func test_addTask_defaultFavoriteFalse() {
        // Arrange
        
        // Act
        viewModel.addTask(title: "Task A", priority: .medium)
        
        // Assert
        XCTAssertFalse(viewModel.tasks[0].isFavorite)
    }
    
    /// Exercise #5 - Marking a favorite
    func test_toggleFavorite_setsIsFavoriteTrue() {
        // Arrange
        viewModel.addTask(title: "Task A", priority: .medium)
        let id = viewModel.tasks[0].id
        
        // Act
        viewModel.toggleFavorite(id: id)
        
        // Assert
        XCTAssertTrue(viewModel.tasks[0].isFavorite)
    }
    
    /// Exercise #6 - A test that passes immediately
    func test_toggleFavorite_setsIsFavoriteFalse() {
        // Arrange
        viewModel.addTask(title: "Task A", priority: .medium)
        let id = viewModel.tasks[0].id
        
        // Act
        viewModel.toggleFavorite(id: id)
        viewModel.toggleFavorite(id: id)
        
        // Assert
        XCTAssertFalse(viewModel.tasks[0].isFavorite)
    }
    
    /// Exercise #7 - Listing favorites
    func test_favoriteTasks_returnsOnlyFavorites() {
        // Arrange
        viewModel.addTask(title: "Task A", priority: .medium)
        viewModel.addTask(title: "Task B", priority: .medium)
        let starredId = viewModel.tasks[1].id
        
        // Act
        viewModel.toggleFavorite(id: starredId)
        
        // Assert
        XCTAssertEqual(viewModel.favoriteTasks.count, 1)
        XCTAssertEqual(viewModel.favoriteTasks.first?.title, "Task B")
    }
    
    // MARK: Class #3
    /// Exercise #8 - Stub Example
    func test_loadTask_returnsStubbedTasks() {
        // Arrange
        let viewModel = TaskListViewModel(service: StubTaskService())
        
        // Act
        viewModel.loadTasks()
        
        // Assert
        XCTAssertEqual(viewModel.tasks.count, 3)
    }
    
    /// Exercise #9 - Stub with custom array
    func test_loadTask_withCustomStubbedData_returnsThatData() {
        // Arrange
        let customTask = [TaskItem(title: "Only one task", priority: .high)]
        let viewModel = TaskListViewModel(service: StubTaskService(stubbedTasks: customTask))
        
        // Act
        viewModel.loadTasks()
        
        // Assert
        XCTAssertEqual(viewModel.tasks.first?.title, "Only one task")
    }
    
    /// Exercise #10 - Mocks Example
    func test_removeTasks_callsServiceDeleteExactlyOnce() {
        // Arrange
        let mockService = MockTaskService(tasksToReturn: [TaskItem(title: "Sample", priority: .medium)])
        let viewModel = TaskListViewModel(service: mockService)
        
        // Act
        viewModel.loadTasks()
        viewModel.removeTask(at: 0)
        
        // Assert
        XCTAssertEqual(mockService.deleteCallCount, 1)
    }
    
    /// Exercise #11 -  Mock Notification Scheduler
    func test_addTask_withDueDate_schedulesReminderExactlyOnce() {
        // Arrange
        let mockScheduler = MockNotificationScheduler()
        let viewModel = TaskListViewModel(notificationScheduler: mockScheduler)
        
        // Act
        viewModel.addTask(title: "Submit Report", dueDate: Date().addingTimeInterval(3600))
        
        // Assert
        XCTAssertEqual(mockScheduler.scheduleCallCount, 1)
    }
    
    /// Exercise #12 - No due date,  no reminder
    func test_addTask_withoutDueDate_doesNotScheduleReminder() {
        // Arrange
        let mockScheduler = MockNotificationScheduler()
        let viewModel = TaskListViewModel(notificationScheduler: mockScheduler)
        
        // Act
        viewModel.addTask(title: "Read a book")
        
        // Assert
        XCTAssertEqual(mockScheduler.scheduleCallCount, 0)
    }
    
    /// Exercise #13 - Overdue with a fake clock
    func test_isOverdue_whenNowIsAfterDueDate_returnsTrue() {
        let due = Date(timeIntervalSince1970: 1_000_000)
        let viewModel = TaskListViewModel(clock: FakeClock(fixedNow: due.addingTimeInterval(60)))
        
        viewModel.addTask(title: "Pay rent", dueDate: due)
        
        XCTAssertTrue(viewModel.isOverdue(viewModel.tasks[0]))
    }
    
    /// Exercise #14 - Not overdue before the due date
    func test_isOverdue_whenNowIsBeforeDueDate_returnsFalse() {
        // Arrange
        let due = Date(timeIntervalSince1970: 1_000_000)
        let viewModel = TaskListViewModel(clock: FakeClock(fixedNow: due.addingTimeInterval(-60)))
        
        // Act
        viewModel.addTask(title: "Pay rent", dueDate: due)
        
        // Assert
        XCTAssertFalse(viewModel.isOverdue(viewModel.tasks[0]))
    }
    
    /// Exercise #15 - Capturing the argument
    func test_addTask_withDueDate_passesTaskToScheduler() {
        // Arrange
        let mockScheduler = MockNotificationScheduler()
        let viewModel = TaskListViewModel(notificationScheduler: mockScheduler)
        let due = Date().addingTimeInterval(3600)
        
        // Act
        viewModel.addTask(title: "Submit Report", dueDate: due)
        
        // Assert
        XCTAssertEqual(mockScheduler.lastScheduleTasks?.title, "Submit Report")
        XCTAssertEqual(mockScheduler.lastScheduleTasks?.dueDate, due)
    }
    
    /// Exercise #16 - Completed tasks are never overdue
    func test_isOverdue_forCompletedTask_returnsFalse() {
        // Arrange
        let due = Date(timeIntervalSince1970: 1_000_000)
        let viewModel = TaskListViewModel(clock: FakeClock(fixedNow: due.addingTimeInterval(60)))
        viewModel.addTask(title: "Pay rent", dueDate: due)
        
        // Act
        viewModel.toggleCompletion(id: viewModel.tasks[0].id)
        
        // Assert
        XCTAssertFalse(viewModel.isOverdue(viewModel.tasks[0]))
    }
    
    /// Exercise #17 - In-memory fake store
    func test_removeTask_deletesTaskFromStore() {
        // Arrange
        let store = FakeTaskStore(tasks: [TaskItem(title: "Task A"), TaskItem(title: "Task B")])
        let viewModel = TaskListViewModel(service: store)
        viewModel.loadTasks()
        
        // Act
        viewModel.removeTask(at: 0)
        
        // Assert
        XCTAssertEqual(store.fetchTasks().map(\.title), ["Task B"])
    }
}
