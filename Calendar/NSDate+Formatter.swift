//
//  NSDate+Formatter.swift
//  Calendar
//
//  Created by qmc on 16/11/1.
//  Copyright © 2016年 刘俊杰. All rights reserved.
//

import Foundation

extension NSDate {

   func day() ->Int {
        let components = NSCalendar.currentCalendar().components([.Year, .Month,. Day], fromDate: self)
        return components.day
    }
    
    func month() ->Int {
        
        let components = NSCalendar.currentCalendar().components([.Year, .Month,. Day], fromDate: self)
        return components.month
    }
    
    func year()-> Int {
        let components = NSCalendar.currentCalendar().components([.Year, .Month,. Day], fromDate: self)
        return components.year
    }
    //MARK: DateFormat
    /**
      把date转成"yyyy-MM"形式的字符串
     
     - returns: "yyyy-MM"
     */
    func stringWithyyyyMMByLine()->String {
        return stringWithDateFormat("yyyy-MM")
    }
    
    func stringWithmmddByLine()->String {
        return stringWithDateFormat("MM-dd")
    }
    
    func stringWithmmddByChinese()->String{
        return stringWithDateFormat("MM月dd日")
    }
    /**
     HH:mm:ss
     
     - returns: HH:mm:ss
     */
    func stringWithHHmmss()->String{
       return stringWithDateFormat("HH:mm:ss")
    }
    
    func stringWithyyyyMMddByLine()->String{
        return stringWithDateFormat("yyyy-MM-dd")
    }
    
    /**
     根据dateFormat转换成相应格式的字符串
     
     - parameter dateFormat: dateFormat
     
     - returns: 日期的格式化字符串
     */
    func stringWithDateFormat(dateFormat: String)->String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.stringFromDate(self)
    }
    /**
     生成当月第几天的NSDate
     
     - parameter day: 设定的天数
     
     - returns: 当月设定天数的日期
     */
    func dateOfCurrentMonthWithNumber(day: Int) ->NSDate {
        let greCalendar = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)
        greCalendar?.timeZone = NSTimeZone(name: "GMT")!
        let comps = greCalendar?.components([.Year,.Month,.Day], fromDate: self)
        comps?.day = day
        let date = greCalendar?.dateFromComponents(comps!)
        return date!
    }
    
    //isDate(date1: NSDate, equalToDate date2: NSDate, toUnitGranularity unit: NSCalendarUnit) -> Bool
    func isSameDay(date: NSDate) -> Bool {
        let calendar = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)
        calendar?.timeZone = NSTimeZone(name: "GMT")!
        let flag = calendar?.isDate(self, equalToDate: date, toUnitGranularity: .Day)
//        let flag = self.stringWithyyyyMMddByLine() == date.stringWithyyyyMMddByLine()
        return flag!
    }
    
    /**
     这个月有多少天
     
     - returns: 这个月有多少天
     */
    func numberOfDaysInCurrentMonth() -> Int {
        // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
        let calendar = NSCalendar.currentCalendar()
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: self)
        return range.length
    }
    
    // 这个月的第一天是星期几
    func firstWeekdayInCurrentMonth() ->Int{
        
        let calendar = NSCalendar.currentCalendar()
        
        calendar.firstWeekday = 1 //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let comp = calendar.components([.Year, .Month, .Day], fromDate: self)
        
        comp.day = 1
        let firstDayOfMonthDate = calendar.dateFromComponents(comp)
        let firstWeekday = calendar.ordinalityOfUnit(.Weekday, inUnit: .WeekOfMonth, forDate: firstDayOfMonthDate!)
        return firstWeekday
    }
    
    func firstDayOfCurrentMonth() ->NSDate {
        var startDate: NSDate?
        let ok = NSCalendar.currentCalendar().rangeOfUnit(.Month, startDate: &startDate, interval: nil, forDate: self)
        assert(ok, "Failed to calculate the first day of the month based on \(self)")
        return startDate!
    }
    
    func weeklyOrdinality() ->Int {
        let calendar = NSCalendar.currentCalendar()
        return calendar.ordinalityOfUnit(.Day, inUnit: .Weekday, forDate: self)
    }
    
    func monthlyOrdinality() ->Int {
        let calendar = NSCalendar.currentCalendar()
        return calendar.ordinalityOfUnit(.Day, inUnit: .Month, forDate: self)
    }
    
    func numberOfWeeksInCurrenMonth()->Int {
 
        let weekday = self.firstDayOfCurrentMonth().weeklyOrdinality()
        
        var days = self.numberOfDaysInCurrentMonth()
        var weeks = 0
        
        if weekday > 1 {
            weeks += 1
            days -= (7 - weekday + 1)
        }
        
        weeks += days / 7
        weeks += (days % 7 > 0) ? 1 : 0
        return weeks
    }
    
    func lastDayOfCurrentMonth() ->NSDate {
        
        let calendarUnit: NSCalendarUnit = [.Year, .Month, .Day]
        let dateComponents: NSDateComponents = NSCalendar.currentCalendar().components(calendarUnit, fromDate: self)
        dateComponents.day = self.numberOfDaysInCurrentMonth()
        return NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
    }
    
    func dayInThePreviousMonth() ->NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.month = -1
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue:0))!
    }
    
    func dayInTheFollowingMonth() ->NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.month = +1
        let newDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self, options: .MatchStrictly)!
        print(newDate)
       return newDate
    }
    
    func YMDComponents() ->NSDateComponents {
        let unitFlags: NSCalendarUnit = [.Year, .Month, .Day]
        return NSCalendar.currentCalendar().components(unitFlags, fromDate: self)
    }
    
    func weekNumberInCurrentMonth() ->Int {
        
        let firstDay = self.firstDayOfCurrentMonth().weeklyOrdinality()
        
        let weeksCount = self.numberOfWeeksInCurrenMonth()
        var weekNumber = 0
        
        let c = self.YMDComponents()
        var startIndex = self.firstDayOfCurrentMonth().monthlyOrdinality()
        var endIndex = startIndex + (7 - firstDay)
        for i in 0..<weeksCount {
            if c.day >= startIndex && c.day <= endIndex{
                weekNumber = i
            }
            startIndex = endIndex + 1
            endIndex = startIndex + 6
        }
        return weekNumber
    }
}