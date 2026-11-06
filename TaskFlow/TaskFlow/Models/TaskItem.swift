//
//  TaskItem.swift
//  TaskFlow
//
//  Created by Andres de la Cruz on 9/30/26.
//

import Foundation

struct TaskItem: Identifiable, Equatable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
    var priority: Priority = .medium
    var isFavorite: Bool = false
    var dueDate: Date? = nil
    
    func isOverdue(now: Date) -> Bool {
        guard let dueDate, !isCompleted else { return false }
        return dueDate < now
    }
}

enum Priority: String, CaseIterable {
    case low, medium, high
}
