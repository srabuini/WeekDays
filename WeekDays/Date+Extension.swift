//
//  Date+Extension.swift
//  WeekDays
//
//  Created by Sebastian Rabuini on 27/01/2022.
//

import Foundation

extension Date {
    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }
}
