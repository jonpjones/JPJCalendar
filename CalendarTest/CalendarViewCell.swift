//
//  CalendarViewCell.swift
//  CalendarTest
//
//  Created by Jonathan Jones on 8/12/16.
//  Copyright © 2016 Mobile Makers. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {
    
    enum BackgroundState {
        case OutOfMonth
        case Highlighted
        case CurrentDay
        case Past
        case Future
        case NoWeek
    }
    
    @IBOutlet weak var outlineView: UIView!
    @IBOutlet weak var dayTextLabel: UILabel!    
    @IBOutlet weak var circleView: UIView!
    
    var date: BDate?
    var selectedCircle: CAShapeLayer?
    var indexPath: NSIndexPath?
    
    var state: BackgroundState? {
        didSet {
            switch state! {
            case .OutOfMonth: outOfMonth()
            case .Highlighted: highlighted()
            case .CurrentDay: currentDay()
            case .Past: past()
            case .Future: future()
            case .NoWeek: noWeek()
            }
            selected = false
        }
    }
    
    
    
    override func awakeFromNib() {
        dayTextLabel.adjustsFontSizeToFitWidth = true
        dayTextLabel.backgroundColor = .clearColor()
        dayTextLabel.textColor = .blueColor()
    }
    
    func outOfMonth() {
        date = nil
        indexPath = nil
        outlineView.layer.borderColor = UIColor.clearColor().CGColor
        circleView.backgroundColor = .lightGrayColor()
        circleView.alpha = 0.4
        dayTextLabel.text?.removeAll()
    }
    
    func highlighted() {
        outlineView.layer.borderColor = UIColor.spotterLightBlue().CGColor
        outlineView.layer.borderWidth = 1
        dayTextLabel.textColor = .whiteColor()
        circleView.backgroundColor = .spotterLightBlue()
        circleView.alpha = 1
        
    }
    
    func currentDay() {
        circleView.backgroundColor = .spotterRed()
        circleView.alpha = 1
        outlineView.layer.borderColor = UIColor.clearColor().CGColor
        outlineView.layer.borderWidth = 1
        dayTextLabel.textColor = .whiteColor()
    }
    
    func past() {
        circleView.backgroundColor = .spotterDarkGray()
        dayTextLabel.textColor = UIColor.whiteColor()
        circleView.alpha = 1
        outlineView.layer.borderWidth = 1
        outlineView.layer.borderColor = UIColor.spotterLightGray().CGColor
    }
    
    func future() {
        circleView.alpha = 1
        dayTextLabel.textColor = UIColor.whiteColor()
        circleView.backgroundColor = .spotterDarkGray()
        outlineView.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func noWeek() {
        indexPath = nil
        date = nil
        circleView.alpha = 1
        circleView.backgroundColor = .clearColor()
        outlineView.layer.borderColor = UIColor.clearColor().CGColor
        dayTextLabel.text?.removeAll()
    }
    
    func selected(animated: Bool) {
        selectedCircle = CAShapeLayer()
        selectedCircle!.bounds = outlineView.bounds
        selectedCircle?.frame.origin = CGPoint(x: 0, y: 0)
        
        let circlePath = UIBezierPath(arcCenter: outlineView.center, radius: outlineView.frame.width / 2, startAngle: CGFloat(-M_PI / 2), endAngle: (CGFloat(7 * M_PI / 2)), clockwise: true)
        selectedCircle!.path = circlePath.CGPath
        
        selectedCircle!.strokeColor = UIColor.spotterRed().CGColor
        
        selectedCircle!.lineWidth = 1
        selectedCircle!.fillColor = UIColor.clearColor().CGColor
        
        layer.addSublayer(selectedCircle!)
        
        if animated {
            selectedCircle?.strokeEnd = 0
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.4
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            selectedCircle?.strokeEnd = 1
            selectedCircle!.addAnimation(animation, forKey: nil)
        } else {
            selectedCircle?.strokeEnd = 1
        }
    }
    
    func deselected() {
        selected = false
        selectedCircle?.removeFromSuperlayer()
        selectedCircle = nil
    }
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func formatBackgroundView(width: CGFloat, height: CGFloat) {
        let sideLength = min(width - 17, height - 17)
        outlineView.layer.cornerRadius = (sideLength + 12) / 2
        circleView.layer.cornerRadius = sideLength / 2
        circleView.clipsToBounds = true
    }

}
