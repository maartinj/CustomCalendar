//
//  Date+Extension.swift
//  Custom Calendar
//
//  Created by Marcin Jędrzejak on 20/04/2024.
//

import Foundation

extension Date {
    static var firstDayOfWeek = Calendar.current.firstWeekday
    static var capitalizedFirstLettersOfWeekdays: [String] {
        let calendar = Calendar.current
//        let weekdays = calendar.shortWeekdaySymbols
        
//        return weekdays.map { weekday in
//            guard let firstLetter = weekday.first else { return "" }
//            return String(firstLetter).capitalized
//        }
        // Adjusted for the different weekday starts
        var weekdays = calendar.shortWeekdaySymbols
        if firstDayOfWeek > 1 {
            for _ in 1..<firstDayOfWeek {
                if let first = weekdays.first {
                    weekdays.append(first)
                    weekdays.removeFirst()
                }
            }
        }
        return weekdays.map { $0.capitalized }
    }
    
    static var fullMonthNames: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        return (1...12).compactMap { month in
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
            let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
            return date.map { dateFormatter.string(from: $0) }
        }
    }

    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }

    var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }

    var startofPreviousMonth: Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }

    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }

//    var sundayBeforeStart: Date {
//        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
//        let numberFromPreviousMonth = startOfMonthWeekday - 1
//        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
//    }

    // New to accomodate for different start of week days
    var firstWeekDayBeforeStart: Date {
        let startMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        let numberFromPreviousMonth = startMonthWeekday - Self.firstDayOfWeek
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }

    var calendarDisplayDates: [Date] {
        var days: [Date] = []
        // Current month days
        for dayOffset in 0..<numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth)
            days.append(newDay!)
        }
        // Add previous month days
        for dayOffset in 0..<startofPreviousMonth.numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startofPreviousMonth)
            days.append(newDay!)
        }

//        return days.filter { $0 >= sundayBeforeStart && $0 <= endOfMonth }.sorted(by: <)
        return days.filter { $0 >= firstWeekDayBeforeStart && $0 <= endOfMonth }.sorted(by: <)
    }

    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
