//
//  Date+Formatter.swift
//  Calendar
//
//  Created by hzf on 16/11/1.
//  Copyright © 2016年 hzf. All rights reserved.
//

import Foundation

extension Date {

   func day() ->Int {
        let components = (Foundation.Calendar.current as NSCalendar).components([.year, .month,. day], from: self)
        return components.day!
    }
    
    func month() ->Int {
        
        let components = (Foundation.Calendar.current as NSCalendar).components([.year, .month,. day], from: self)
        return components.month!
    }
    
    func year()-> Int {
        let components = (Foundation.Calendar.current as NSCalendar).components([.year, .month,. day], from: self)
        return components.year!
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
    func stringWithDateFormat(_ dateFormat: String)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    /**
     生成当月第几天的NSDate
     
     - parameter day: 设定的天数
     
     - returns: 当月设定天数的日期
     */
    func dateOfCurrentMonthWithNumber(_ day: Int) ->Date {
        var greCalendar = Foundation.Calendar(identifier:Calendar.Identifier.gregorian)
        greCalendar.timeZone = TimeZone(identifier: "GMT")!
        var comps = (greCalendar as NSCalendar?)?.components([.year,.month,.day], from: self)
        comps?.day = day
        let date = greCalendar.date(from: comps!)
        return date!
    }
    
    //isDate(date1: NSDate, equalToDate date2: NSDate, toUnitGranularity unit: NSCalendarUnit) -> Bool
    func isSameDay(_ date: Date) -> Bool {
        var calendar = Foundation.Calendar(identifier:Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let flag = (calendar as NSCalendar?)?.isDate(self, equalTo: date, toUnitGranularity: .day)
//        let flag = self.stringWithyyyyMMddByLine() == date.stringWithyyyyMMddByLine()
        return flag!
    }
    
    /**
     这个月有多少天
     
     - returns: 这个月有多少天
     */
    func numberOfDaysInCurrentMonth() -> Int {
        // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
        let calendar = Foundation.Calendar.current
        let range = (calendar as NSCalendar).range(of: .day, in: .month, for: self)
        return range.length
    }
    
    // 这个月的第一天是星期几
    func firstWeekdayInCurrentMonth() ->Int{
        
        var calendar = Foundation.Calendar.current
        
        calendar.firstWeekday = 1 //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        var comp = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        
        comp.day = 1
        let firstDayOfMonthDate = calendar.date(from: comp)
        let firstWeekday = (calendar as NSCalendar).ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekday
    }
    
    func firstDayOfCurrentMonth() ->Date {
        var startDate: NSDate?
        let ok = (Foundation.Calendar.current as NSCalendar).range(of: .month, start: &startDate , interval: nil, for: self)
        assert(ok, "Failed to calculate the first day of the month based on \(self)")
        return startDate! as Date
    }
    
    func weeklyOrdinality() ->Int {
        let calendar = Foundation.Calendar.current
        return (calendar as NSCalendar).ordinality(of: .day, in: .weekday, for: self)
    }
    
    func monthlyOrdinality() ->Int {
        let calendar = Foundation.Calendar.current
        return (calendar as NSCalendar).ordinality(of: .day, in: .month, for: self)
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
    
    func lastDayOfCurrentMonth() ->Date {
        
        let calendarUnit: NSCalendar.Unit = [.year, .month, .day]
        var dateComponents: DateComponents = (Foundation.Calendar.current as NSCalendar).components(calendarUnit, from: self)
        dateComponents.day = self.numberOfDaysInCurrentMonth()
        return Foundation.Calendar.current.date(from: dateComponents)!
    }
    
    func dayInThePreviousMonth() ->Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        return (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue:0))!
    }
    
    func dayInTheFollowingMonth() ->Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: .matchStrictly)!
        print(newDate)
       return newDate
    }
    
    func YMDComponents() ->DateComponents {
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        return (Foundation.Calendar.current as NSCalendar).components(unitFlags, from: self)
    }
    
    func weekNumberInCurrentMonth() ->Int {
        
        let firstDay = self.firstDayOfCurrentMonth().weeklyOrdinality()
        
        let weeksCount = self.numberOfWeeksInCurrenMonth()
        var weekNumber = 0
        
        let c = self.YMDComponents()
        var startIndex = self.firstDayOfCurrentMonth().monthlyOrdinality()
        var endIndex = startIndex + (7 - firstDay)
        for i in 0..<weeksCount {
            if c.day! >= startIndex && c.day! <= endIndex{
                weekNumber = i
            }
            startIndex = endIndex + 1
            endIndex = startIndex + 6
        }
        return weekNumber
    }
}
