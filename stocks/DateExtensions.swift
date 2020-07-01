//
//  DateExtensions.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/29/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation

extension Date {
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    func getDaysFromOct171997() -> Int {
        
        let start = DateComponents(year: 1997, month: 10, day: 17)
        return Calendar.current.dateComponents([.day], from: Calendar.current.date(from: start)!, to: self).day!
    }
    
    func getDayOfYear() -> Int {
        if let doy = Calendar.current.ordinality(of: .day, in: .year, for: self) {
            return doy
        }
        else {
            return -1
        }
    }

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}
