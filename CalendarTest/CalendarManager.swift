//
//  CalendarManager.swift
//  CalendarTest
//
//  Created by Jonathan Jones on 8/12/16.
//  Copyright © 2016 Mobile Makers. All rights reserved.
//

import Foundation
import UIKit

protocol SetMonthNameDelegate {
    func setMonthName(name: String)
    func shouldShowSecondaryView(date: BDate) -> Bool
}

private let YearUnit = NSCalendarUnit.Year
private let MonthUnit = NSCalendarUnit.Month
private let DayUnit = NSCalendarUnit.Day
private let WeekUnit = NSCalendarUnit.WeekOfMonth
private let WeekdayUnit = NSCalendarUnit.Weekday

class CalendarManager {
    var pastMonth: Month?
    var currentMonth: Month?
    var nextMonth: Month?
    var delegate: SetMonthNameDelegate?
    
    
    func getCurrentMonth(date: NSDate) {
        currentMonth = Month(date: date)
        setMonthLabelName()
    }
    
    func setMonthLabelName(){
        delegate?.setMonthName("\(currentMonth!.name), \(currentMonth!.yearInt)")
    }
    
    func getNextMonth(){
        var month = Int()
        var year = Int()
        if currentMonth!.monthInt == 12 {
            month = 1
            year = currentMonth!.yearInt + 1
        } else {
            month = currentMonth!.monthInt + 1
            year = currentMonth!.yearInt
        }
        nextMonth = Month(month: month, year: year)
    }
    
    func getPastMonth() {
        var month = Int()
        var year = Int()
        if currentMonth!.monthInt == 1 {
            month = 12
            year = currentMonth!.yearInt - 1
        } else {
            month = currentMonth!.monthInt - 1
            year = currentMonth!.yearInt
        }
        pastMonth = Month(month: month, year: year)
    }
    
    func scrolledNext() {
        pastMonth = currentMonth
        currentMonth = nextMonth
        getNextMonth()
        setMonthLabelName()
    }
    
    func scrolledPrevious() {
        nextMonth = currentMonth
        currentMonth = pastMonth
        getPastMonth()
        setMonthLabelName()
    }
    
    func layoutForIndexPath (indexPath: NSIndexPath, cell: CalendarViewCell) -> CalendarViewCell {
        let weekIndex = indexPath.item / 7
        let dayIndex = indexPath.item % 7
        let monthIndex = indexPath.section
        let month: Month?
        
        switch monthIndex {
        case 0: month = pastMonth
        case 1: month = currentMonth
        case 2: month = nextMonth
        default: return cell
        }
        
        if month != nil {
            let week = month!.weeksArray[weekIndex]
            for day in week {
                if day.weekDay - 1 == dayIndex {
                    cell.dayTextLabel.text = String(day.dayOfMonth)
                    cell.date = day
//                    print("-----")
//                    print("Cell DOM: \(cell.date?.dayOfMonth)")
//                    print("Cell DTL: \(cell.dayTextLabel!.text)")
                    if String(cell.date!.dayOfMonth) != cell.dayTextLabel.text! {
                        print("Uh Oh")

                    }
                    if day.currentDay {
                        cell.state = .CurrentDay
                        
                        return cell
                    }
                    if delegate!.shouldShowSecondaryView(day) {
                        cell.state = .Highlighted
                        return cell
                    }
                    if day.isPastDay() {
                        cell.state = .Past
                        return cell
                    }
                    cell.state = .Future
                    return cell
                }
            }
            if week.count == 0 {
                cell.state = .NoWeek
                return cell
            }
            cell.state = .OutOfMonth
            return cell
        }
        return cell
    }
    
    static func dateRange(date: NSDate) -> (year: Int, month: Int, weekOfMonth: Int, weekday: Int, day: Int) {
        let components = componentsForDate(date)
        
        let year = components.year
        let month = components.month
        let weekOfMonth = components.weekOfMonth
        let day = components.day
        let weekday = components.weekday
        
        return (year, month, weekOfMonth, weekday, day)
    }
}

extension CalendarManager {
    static func componentsForDate(date: NSDate) -> NSDateComponents {
        let units = YearUnit.union(MonthUnit).union(WeekUnit).union(WeekdayUnit).union(DayUnit)
        let components = NSCalendar.currentCalendar().components(units, fromDate: date)
        return components
    }
    
    static func dateFromYear(year: Int, month: Int, week: Int, day: Int) -> NSDate? {
        let comps = Manager.componentsForDate(NSDate())
        comps.year = year
        comps.month = month
        comps.weekOfMonth = week
        comps.day = day
        return NSCalendar.currentCalendar().dateFromComponents(comps)
    }
}