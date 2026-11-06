//
//  FakeClock.swift
//  TaskFlow
//
//  Created by Andres de la Cruz on 11/5/26.
//

import Foundation
@testable import TaskFlow

struct FakeClock: ClockProtocol {
    let fixedNow: Date
    
    func now() -> Date {
        fixedNow
    }
}
