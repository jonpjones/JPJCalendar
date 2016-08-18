//
//  MonthView.swift
//  CalendarTest
//
//  Created by Jonathan Jones on 8/12/16.
//  Copyright © 2016 Mobile Makers. All rights reserved.
//

import UIKit

class Month: NSObject {
    let calendar = NSCalendar.currentCalendar()
    let components = NSDateComponents()
    var dayArray: [BDate]?
    let firstWeekDay: Int?
    let numberOfdays: Int?
    let monthInt: Int
    let yearInt: Int
    let name: String
    
    
    var weeksArray: [[BDate]] {
        get {
            return [weekOneArray,weekTwoArray,weekThreeArray,weekFourArray,weekFiveArray,weekSixArray]
        }
    }
    
    var weekOneArray = [BDate]()
    var weekTwoArray = [BDate]()
    var weekThreeArray = [BDate]()
    var weekFourArray = [BDate]()
    var weekFiveArray = [BDate]()
    var weekSixArray = [BDate]()
    
    init(month: Int, year: Int) {
        monthInt = month
        yearInt = year
        components.month = month
        components.year = year
        name = month.monthString()
        let date = calendar.dateFromComponents(components)
        firstWeekDay = calendar.component(.Weekday, fromDate: date!)
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date!)
        numberOfdays = range.length
        super.init()
        dayArray = []
        getDaysForMonth()
    }
    
    init(date: NSDate) {
        components.month = calendar.component(.Month, fromDate: date)
        components.year = calendar.component(.Year, fromDate: date)
        monthInt = components.month
        yearInt = components.year
        let firstDate = calendar.dateFromComponents(components)
        firstWeekDay = calendar.component(.Weekday, fromDate: firstDate!)
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: firstDate!)
        numberOfdays = range.length
        name = components.month.monthString()
        super.init()
        dayArray = []
        getDaysForMonth()
    }
    
    func getDaysForMonth() {
        for i in 1...numberOfdays! {
            components.day = i
            let date = calendar.dateFromComponents(components)
            let dateObject = BDate(withDate: date!)
            switch dateObject.weekOfMonth {
            case 1: weekOneArray.append(dateObject)
            case 2: weekTwoArray.append(dateObject)
            case 3: weekThreeArray.append(dateObject)
            case 4: weekFourArray.append(dateObject)
            case 5: weekFiveArray.append(dateObject)
            case 6: weekSixArray.append(dateObject)
            default: print("Error")
            }
            dayArray?.append(dateObject)
        }
    }
}
