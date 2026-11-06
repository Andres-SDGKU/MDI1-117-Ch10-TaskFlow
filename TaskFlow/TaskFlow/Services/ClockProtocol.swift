//
//  ClockProtocol.swift
//  TaskFlow
//
//  Created by Andres de la Cruz on 11/5/26.
//

import Foundation

protocol ClockProtocol {
    func now() -> Date
}

struct SystemClock: ClockProtocol {
    func now() -> Date {
        Date()
    }
}
