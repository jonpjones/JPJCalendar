//
//  Date.swift
//  CalendarTest
//
//  Created by Jonathan Jones on 8/12/16.
//  Copyright © 2016 Mobile Makers. All rights reserved.
//

import UIKit

typealias Manager = CalendarManager

public class BDate: NSObject {
    
    private let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    private var date: NSDate?
    public var dayOfMonth: Int
    public var month: Int
    public var year: Int
    public var weekOfMonth: Int
    public var weekDay: Int
    
    public var currentDay: Bool {
        get {
            return isCurrentDay()
        }
    }
    
    init(withDate: NSDate) {
        let dateRange = Manager.dateRange(withDate)
        date = withDate
        dayOfMonth = dateRange.day
        year = dateRange.year
        month = dateRange.month
        weekOfMonth = dateRange.weekOfMonth
        weekDay = dateRange.weekday
        super.init()
    }
    
    func convertedDate() -> NSDate {
        return date!
    }
    
    func isCurrentDay() -> Bool {
       return calendar!.isDate(date!, inSameDayAsDate: NSDate())
    }
    
    func isPastDay() -> Bool {
        if date?.compare(NSDate()) == .OrderedAscending {
            return true
        }
        return false
    }
}

extension Int {
    func monthString() -> String  {
        switch self {
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default: return "Input Error"
        }
    }
    
    func weekdayString() -> String {
        switch self {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "Input Error"
        }
    }
}


