//
//  CalendarView.swift
//  CalendarTest
//
//  Created by Jonathan Jones on 8/12/16.
//  Copyright © 2016 Mobile Makers. All rights reserved.
//

import UIKit

protocol CalendarDelegate {
    func shouldShowSecondaryViewForDays(date: BDate) -> Bool
}

private let manager = Manager()

class CalendarView: UIView {
    @IBOutlet weak var xibView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarCV: UICollectionView!
    @IBOutlet var weekDayHeaders: [UILabel]!
    
    var cellHeight: CGFloat?
    var cellWidth: CGFloat?
    
    let calendarCellIdentifier = "CalendarViewCell"
    var calendar: NSCalendar?
    
    var delegate: CalendarDelegate?
    var secondaryViewDays: [NSDate]?
    
    var selectedDate: BDate?
    var selectedIndexPath: NSIndexPath?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("CalendarView", owner: self, options: nil)
        for label in weekDayHeaders {
            label.textColor = .spotterDarkGray()
        }
        manager.delegate = self
        setUpCalendar()
    }
    
    func setUpCalendar() {
        calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        addSubview(xibView)
        xibView.frame.size = frame.size
        layoutSubviews()
        
        calendarCV.delegate = self
        calendarCV.dataSource = self
        let nib = UINib.init(nibName: "CalendarViewCell", bundle: NSBundle.mainBundle())
        calendarCV.registerNib(nib, forCellWithReuseIdentifier: calendarCellIdentifier)
        
        manager.getCurrentMonth(NSDate())
        manager.getPastMonth()
        manager.getNextMonth()
        monthLabel.textColor = .spotterDarkGray()
        calendarCV.allowsMultipleSelection = false
        calendarCV.pagingEnabled = true
        calendarCV.showsHorizontalScrollIndicator = true
        calendarCV.showsVerticalScrollIndicator = false
        calendarCV.reloadData()
    }
}

extension CalendarView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CalendarViewCell
        if cell.state == .OutOfMonth {
            return
        }
        if cell.selectedCircle == nil {
            selectedDate = cell.date
            cell.selected(true)
            selectedIndexPath = indexPath
            cell.indexPath = selectedIndexPath!
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CalendarViewCell
        cell.deselected()
    }
}

extension CalendarView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(calendarCellIdentifier, forIndexPath: indexPath) as! CalendarViewCell
        cell = manager.layoutForIndexPath(indexPath, cell: cell)
        
        guard cell.date != nil else { return cell }
        guard selectedDate  != nil else { return cell }
        guard selectedIndexPath != nil else { return cell }
        guard cell.date != nil else {
            cell.deselected()
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
            return cell
        }
  
        if cell.date!.month == selectedDate!.month && cell.date!.dayOfMonth == selectedDate?.dayOfMonth {
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            cell.selected = true
            cell.selected(false)
        } else {
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
            cell.deselected()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let calCell = cell as! CalendarViewCell
        calCell.formatBackgroundView(cellWidth!, height: cellHeight!)
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let calCell = cell as! CalendarViewCell
        calCell.deselected()
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        collectionView.backgroundColor = .whiteColor()
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionHeadersPinToVisibleBounds = false
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * 2)
        cellWidth = CGFloat((collectionView.bounds.width - totalSpace) / CGFloat(7) - 0.1)
        cellHeight = collectionView.frame.height / 6
        
        collectionView.setContentOffset(CGPoint(x:collectionView.frame.origin.x, y:collectionView.frame.height), animated: false)
        
        return CGSizeMake(cellWidth!, cellHeight!)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = calendarCV.contentOffset.y / calendarCV.frame.height
        if page == 0 {
            manager.scrolledPrevious()
        } else if page == 2 {
            manager.scrolledNext()
        }
        calendarCV.reloadData()
        calendarCV.setContentOffset(CGPoint(x:calendarCV.frame.origin.x,y: calendarCV.frame.height), animated: false)
    }
}

extension CalendarView: SetMonthNameDelegate {
    func setMonthName(name: String) {
        animateLabelOut(name)
    }
    
    func shouldShowSecondaryView(date: BDate) -> Bool {
        return delegate!.shouldShowSecondaryViewForDays(date)
    }
    
    func animateLabelOut(name: String) {
        UIView.animateWithDuration(0.2, animations: {
            self.monthLabel.alpha = 0
        }) { (bool) in
            self.monthLabel.text = name
            self.animateLabelIn()
        }
    }
    
    func animateLabelIn() {
        UIView.animateWithDuration(0.2, animations: {
            self.monthLabel.alpha = 1
        })
    }
    
}

