//
//  ViewController.swift
//  CalendarTest
//
//  Created by Jonathan Jones on 8/12/16.
//  Copyright © 2016 Mobile Makers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var calendarView: CalendarView!
    
    var dateArray = ["August 5, 2016", "August 9, 2016", "August 1, 2016", "July 27, 2016"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        let date = formatter.dateFromString("August 5, 2016")
        calendarView.delegate = self
    }
}

extension ViewController: CalendarDelegate {
    func shouldShowSecondaryViewForDays(date: BDate) -> Bool {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        for string in dateArray {
            let ndate = formatter.dateFromString(string)
            let bdate = BDate(withDate: ndate!)
            
            if date.convertedDate() == bdate.convertedDate() {
                return true
            }
        }
        return false
    }
}

