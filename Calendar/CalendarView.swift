//
//  CalendarView.swift
//  Calendar
//
//  Created by qmc on 16/11/1.
//  Copyright © 2016年 刘俊杰. All rights reserved.
//

import UIKit

let calendarCellIdentifier = "calendarCellIdentifier"
class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var date: NSDate! {
        didSet{
            monthLabel.text = "\(date.month())-\(date.year())"
            getDateModel(date)
            collectionView.reloadData()
        }
    }
    var today: NSDate!
    
    var collectionView: UICollectionView!
    
    var monthLabel: UILabel!
    
    var previouBtn: UIButton!
    
    var nextBtn: UIButton!
    
    var weekDayArray: [String]!
    var dayModelArray: [AnyObject]!
    
    var mask: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        weekDayArray = ["日", "一", "二", "三", "四", "五", "六"]
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getDateModel(date: NSDate)  {
        let days = date.numberOfDaysInCurrentMonth()
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let week = date.firstWeekdayInCurrentMonth()
        self.dayModelArray = [AnyObject]()
        
        var day: Int = 1
        
        for i in 1..<days+week {
            if i<week  {
                self.dayModelArray.append("")
            } else {
                let mon = MonthModel()
                mon.dayValue = day
                let dayDate = date.dateOfCurrentMonthWithNumber(day)
                mon.dateValue = dayDate
                if dayDate.isSameDay(today) {
                    mon.isSelectedDay = true
                    print("dayDate: \(dayDate)--------date:\(date)")
                }
                self.dayModelArray.append(mon)
                 day += 1
            }
        }
        
        self.collectionView.reloadData()
    }
    
    func customInterface() {
        let itemWidth = collectionView.frame.size.width / 7
        let itemHeight = collectionView.frame.size.height / 7
        
        print("itemWidth: \(itemWidth)")
        print("itemHeight: \(itemHeight)")
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSizeMake(itemWidth, itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    @objc func previouseAction(sender: UIButton) {
        UIView.transitionWithView(self, duration: 0.5, options: .TransitionCurlDown, animations: { 
            self.date = self.date.dayInThePreviousMonth()
        }) { (flag) in
            
        }
    }
    
    @objc func nextAction(sender: UIButton) {
        UIView.transitionWithView(self, duration: 0.5, options: .TransitionCurlUp, animations: { 
            self.date = self.date.dayInTheFollowingMonth()
        }) { (flag) in
            
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     
     */
    override func drawRect(rect: CGRect) {
        // Drawing code
        customInterface()
    }
}

typealias delegateExtension = CalendarView
extension delegateExtension{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return weekDayArray.count
        }
        
        return self.dayModelArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(calendarCellIdentifier, forIndexPath: indexPath) as! CanlendarCollectionViewCell
        cell.dateLabel.backgroundColor = UIColor.whiteColor()
        cell.dateLabel.textColor = UIColor.blackColor()
        if indexPath.section == 0 {
            cell.monthModel = nil
            cell.dateLabel.text = weekDayArray[indexPath.row]
            cell.dateLabel.textColor = UIColor(rgb: 0x15cc9c)
        } else {
            let mon = self.dayModelArray[indexPath.row]
            if let date = mon as? MonthModel {
                cell.monthModel = date
            } else {
                cell.monthModel = nil
                cell.dateLabel.text = ""
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1 {
            let mon = self.dayModelArray[indexPath.row]
            if let _ = mon as? MonthModel {
                return true
            } else {
              return false
            }
        }
        return false
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let mon = self.dayModelArray[indexPath.row] as! MonthModel
        print("date:---\(mon.dateValue)")
    }
}

typealias setupSubviewExtension = CalendarView

extension setupSubviewExtension {
    
    func setupSubviews() {
    
        monthLabel = UILabel()
        monthLabel.backgroundColor = UIColor(rgb: 0x20C48A)
        monthLabel.text = "20000"
        monthLabel.textColor = UIColor.whiteColor()
        monthLabel.textAlignment = .Center
        previouBtn = UIButton(type: .Custom)
        previouBtn.setTitle("<", forState: .Normal)
        previouBtn.addTarget(self, action: #selector(previouseAction(_:)), forControlEvents: .TouchUpInside)
        
        nextBtn = UIButton(type: .Custom)
        nextBtn.setTitle(">", forState: .Normal)
        nextBtn.addTarget(self, action: #selector(nextAction(_:)), forControlEvents: .TouchUpInside)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSizeMake(50, 50)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(CanlendarCollectionViewCell.self, forCellWithReuseIdentifier: calendarCellIdentifier)
        collectionView.backgroundColor = UIColor.whiteColor()
        self.addSubview(monthLabel)
        self.addSubview(previouBtn)
        self.addSubview(nextBtn)
        self.addSubview(collectionView)
        
        weak var weakself = self
        
        monthLabel.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(weakself!)
            make.height.equalTo(40)
        }
        
        previouBtn.snp_makeConstraints { (make) in
            make.height.top.equalTo((weakself?.monthLabel)!)
            make.left.equalTo((weakself?.monthLabel)!).offset(0)
            make.width.equalTo(60)
        }
        
        nextBtn.snp_makeConstraints { (make) in
            make.height.top.equalTo((weakself?.monthLabel)!)
            make.right.equalTo((weakself?.monthLabel)!).offset(0)
            make.width.equalTo(60)
        }
        
        collectionView.snp_makeConstraints { (make) in
            make.top.equalTo((weakself?.monthLabel.snp_bottom)!)
            make.left.right.bottom.equalTo((weakself)!)
        }
    }
}

