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
}
