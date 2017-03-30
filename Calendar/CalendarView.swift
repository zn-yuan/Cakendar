//
//  CalendarView.swift
//  Calendar
//
//  Created by hzf on 16/11/1.
//  Copyright © 2016年 hzf. All rights reserved.
//

import UIKit

let calendarCellIdentifier = "calendarCellIdentifier"
class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var date: Date! {
        didSet{
            monthLabel.text = "\(date.month())-\(date.year())"
            getDateModel(date)
            collectionView.reloadData()
        }
    }
    var today: Date!
    
    var collectionView: UICollectionView!
    
    var monthLabel: UILabel!
    
    var previouBtn: UIButton!
    
    var nextBtn: UIButton!
    
    var weekDayArray: [String]!
    var dayModelArray: [Any]!
    
//    var mask: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        weekDayArray = ["日", "一", "二", "三", "四", "五", "六"]
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getDateModel(_ date: Date)  {
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
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    @objc func previouseAction(_ sender: UIButton) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCurlDown, animations: { 
            self.date = self.date.dayInThePreviousMonth()
        }) { (flag) in
            
        }
    }
    
    @objc func nextAction(_ sender: UIButton) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCurlUp, animations: { 
            self.date = self.date.dayInTheFollowingMonth()
        }) { (flag) in
            
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     
     */
    override func draw(_ rect: CGRect) {
        // Drawing code
        customInterface()
    }
}

typealias delegateExtension = CalendarView
extension delegateExtension{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return weekDayArray.count
        }
        
        return self.dayModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCellIdentifier, for: indexPath) as! CanlendarCollectionViewCell
        cell.dateLabel.backgroundColor = UIColor.white
        cell.dateLabel.textColor = UIColor.black
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        monthLabel.textColor = UIColor.white
        monthLabel.textAlignment = .center
        previouBtn = UIButton(type: .custom)
        previouBtn.setTitle("<", for: UIControlState())
        previouBtn.addTarget(self, action: #selector(previouseAction(_:)), for: .touchUpInside)
        
        nextBtn = UIButton(type: .custom)
        nextBtn.setTitle(">", for: UIControlState())
        nextBtn.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CanlendarCollectionViewCell.self, forCellWithReuseIdentifier: calendarCellIdentifier)
        collectionView.backgroundColor = UIColor.white
        self.addSubview(monthLabel)
        self.addSubview(previouBtn)
        self.addSubview(nextBtn)
        self.addSubview(collectionView)
        
        weak var weakself = self
        
        monthLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(weakself!)
            make.height.equalTo(40)
        }
        
        previouBtn.snp.makeConstraints { (make) in
            make.height.top.equalTo((weakself?.monthLabel)!)
            make.left.equalTo((weakself?.monthLabel)!).offset(0)
            make.width.equalTo(60)
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.height.top.equalTo((weakself?.monthLabel)!)
            make.right.equalTo((weakself?.monthLabel)!).offset(0)
            make.width.equalTo(60)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo((weakself?.monthLabel.snp.bottom)!)
            make.left.right.bottom.equalTo((weakself)!)
        }
    }
}

