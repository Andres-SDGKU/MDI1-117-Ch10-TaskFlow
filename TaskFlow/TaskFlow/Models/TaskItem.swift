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
}
