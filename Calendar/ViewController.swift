//
//  ViewController.swift
//  Calendar
//
//  Created by hzf on 16/10/31.
//  Copyright © 2016年 hzf. All rights reserved.
//


// 根据提供的日历标示符初始化。
/*
 identifier 的范围可以是:
 
 NSCalendarIdentifierGregorian         公历
 NSCalendarIdentifierBuddhist          佛教日历
 NSCalendarIdentifierChinese           中国农历
 NSCalendarIdentifierHebrew            希伯来日历
 NSCalendarIdentifierIslamic           伊斯兰日历
 NSCalendarIdentifierIslamicCivil      伊斯兰教日历
 NSCalendarIdentifierJapanese          日本日历
 NSCalendarIdentifierRepublicOfChina   中华民国日历（台湾）
 NSCalendarIdentifierPersian           波斯历
 NSCalendarIdentifierIndian            印度日历
 NSCalendarIdentifierISO8601           ISO8601
 */

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        getCaledarSettingInfo()
//        calendarInfo()
//        calendarInfo()
//        rangeOfUnit()
        self.view.backgroundColor = UIColor.gray
        let calendarView = CalendarView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width / 2, height: 200))
        calendarView.today = Date()
        calendarView.date = calendarView.today
        self.view.addSubview(calendarView)
    }
    
    //MARK:---日历的创建
    func calendarCreate() {
        // 根据提供的日历标示符初始化。
        let calendar = Foundation.Calendar(identifier: Calendar.Identifier.gregorian)
        // 返回当前客户端的逻辑日历
        /*
         取得的值会一直保持在 cache 中，第一次用此方法实例化对象后，即使修改了系统日历设定，这个对象也不会改变
         */
        
        let cal2: Foundation.Calendar = Foundation.Calendar.current
        
        // 返回当前客户端的逻辑日历
        /*
         当每次修改系统日历设定，其实例化的对象也会随之改变。
         */
        
        let cal3: Foundation.Calendar = Foundation.Calendar.autoupdatingCurrent
        
    }
    
    
    // MARK: ------日历的设置
    func calendarSet(){
        var calendar: Foundation.Calendar = Foundation.Calendar.current
        // 设置区域
        calendar.locale = Locale(identifier: "zh_CN")
        // 设置时区
        /*
         设置时区，设置为 GMT+8，即北京时间(+8)
         */
        calendar.timeZone = TimeZone(abbreviation: "EST")!
        calendar.timeZone = TimeZone(secondsFromGMT: 28800)!
        
        // 设定每周的第一天从星期几开始
        /*
         1 代表星期日开始，2 代表星期一开始，以此类推。默认值是 1
         */
        calendar.firstWeekday = 2
        // 设置每年及每月第一周必须包含的最少天数
        /*
            设定第一周最少包括 3 天，则 value 传入 3
         */
        calendar.minimumDaysInFirstWeek = 3
    }
 
    //MARK: ---日历设置信息的获取
    func getCaledarSettingInfo() {
        let calendar: Foundation.Calendar = Foundation.Calendar.current
        
        // 获取日历标示符
        /*
         有效的日历标示符包括:
         
                 gregorian
                 buddhist
                 chinese
                 hebrew
                 islamic
                 islamic-civil
                 japanese
                 roc
                 persian
                 indian
                 iso8601
         */
        
        let calendarIndentifier = calendar.identifier
        print("calendarIndentifier:----\(calendarIndentifier)")
        // 获取地区信息
        let localeIdentifier = calendar.locale?.identifier
        let localeIdentifier2 = (calendar.locale as NSLocale?)?.object(forKey: NSLocale.Key(rawValue: "calendarIdentifier"))
        print("localeIdentifier:---\(localeIdentifier) ---or---\(localeIdentifier2)")
        
        // 获取时区信息
        let timeZone = calendar.timeZone
        
        print("time:--\(timeZone)")

    }

    /*
     
     public func ordinalityOfUnit(smaller: NSCalendarUnit, inUnit larger: NSCalendarUnit, forDate date: NSDate) -> Int
     
     NSCalendarUnit包含的值有：
     
     Era               -- 纪元单位。对于 NSGregorianCalendar (公历)来说，只有公元前(BC)和公元(AD)；而对于其它历法可能有很多，
     例如日本和历是以每一代君王统治来做计算。
     Year              -- 年单位。值很大，相当于经历了多少年，未来多少年。
     Month             -- 月单位。范围为1-12
     Day               -- 天单位。范围为1-31
     Hour              -- 小时单位。范围为0-24
     Minute            -- 分钟单位。范围为0-60
     Second            -- 秒单位。范围为0-60
     Weekday           -- 星期单位，每周的7天。范围为1-7
     WeekdayOrdinal    -- 没完全搞清楚
     
     Quarter           -- 几刻钟，也就是15分钟。范围为1-4
     WeekOfMonth       -- 月包含的周数。最多为6个周
     WeekOfYear        -- 年包含的周数。最多为53个周
     YearForWeekOfYear -- 没完全搞清楚
     Nanosecond        -- 微妙
     Calendar          --
     TimeZone          -- 没完全搞清楚
     
     <1>、当小单位为 NSCalendarUnitWeekday，大单位为 NSCalendarUnitWeekOfMonth / NSCalendarUnitWeekOfYear 时
     (即某个日期在这一周是第几天)，根据 firstWeekday 属性不同，返回的结果也不同。具体说明如下:
     
     当 firstWeekday 被指定为星期天(即 = 1)时，它返回的值与星期几对应的数值保持一致。比如:
     fromDate 传入的参数是星期日，则函数返回 1
     fromDate 传入的参数是星期一，则函数返回 2
     当 firstWeekday 被指定为其它值时(即 <> 1)时，假设firstWeekday 被指定为星期一(即 = 2)，那么:
     fromDate 传入的参数是星期一，则函数返回 1
     fromDate 传入的参数是星期二，则函数返回 2
     fromDate 传入的参数是星期日，则函数返回 7
     
     <2>、当小单位为 参数为 NSCalendarUnitWeekOfMonth / NSCalendarUnitWeekOfYear，大单位为 NSCalendarUnitYear 时
     (即某个日期在这一年中是第几周)，minimumDaysInFirstWeek 属性影响它的返回值。具体说明如下:
     
     2005年1月
     日   一    二   三   四    五   六
     --------------------------------
     1
     2    3    4    5    6    7    8
     9    10   11   12   13   14   15
     16   17   18   19   20   21   22
     23   24   25   26   27   28   29
     30   31
     
     2005年1月第一周包括1号。
     a. 如果将 minimumDaysInFirstWeek 设定 = 1
     则 fromDate 传入1月1号，方法均返回1  ==> 满足 minimumDaysInFirstWeek 指定的天数(最少1天)，所以方法将其归为
     2005年的第1周
     则 fromDate 传入1月2-8号，方法均返回2
     则 fromDate 传入1月9-15号，方法均返回3
     ......
     
     b. 如果将 minimumDaysInFirstWeek 设定为 > 1，比如2
     则 fromDate 传入1月1号，方法均返回53  ==> 不足2天，所以方法将其归为2004年的第53周
     则 fromDate 传入1月2-8号，方法均返回1
     则 fromDate 传入1月9-15号，方法均返回2
     ......
     
     2008年1月
     日   一    二   三   四    五   六
     ---------------------------------
     1    2    3    4    5
     6    7    8    9    10   11   12
     13   14   15   16   17   18   19
     20   21   22   23   24   25   26
     27   28   29   30   31
     
     2005年1月第一周包括1-5号共5天。
     a. 如果将 minimumDaysInFirstWeek 设定为 <= 5时
     则 fromDate 传入1月1-5号，方法均返回1  ==> 满足 minimumDaysInFirstWeek 指定的天数，所以方法将其归为
     2008年的第1周
     则 fromDate 传入1月6-12号，方法均返回2
     则 fromDate 传入1月13-19号，方法均返回3
     ......
     
     b. 如果将 minimumDaysInFirstWeek 设定为 > 5，比如6
     则 fromDate 传入1月1-5号，方法均返回53  ==> 当周不足6天，所以方法将其归为2007年的第53周
     则 fromDate 传入1月2-8号，方法均返回1
     则 fromDate 传入1月9-15号，方法均返回2
     ......
     
     <3>、当小单位为 参数为 NSCalendarUnitWeekOfMonth / NSCalendarUnitWeekOfYear，大单位为 NSCalendarUnitMonth 时
     (即某个日期在这一个月中是第几周)，minimumDaysInFirstWeek 属性影响它的返回值。具体说明如下:
     
     2008年4月
     日   一    二   三   四    五   六
     ---------------------------------
     1    2    3    4    5
     6    7    8    9    10   11   12
     13   14   15   16   17   18   19
     20   21   22   23   24   25   26
     27   28   29   30
     
     2008年4月第一周包括1、2、3、4、5号。
     a. 如果将 minimumDaysInFirstWeek 设定为小于或等于5的数
     则 fromDate 传入4月1-5号，方法均返回1
     则 fromDate 传入4月6-12号，方法均返回2
     则 fromDate 传入4月13-19号，方法均返回3
     ....
     
     b. 如果将 minimumDaysInFirstWeek 设定为大于5的数
     则 fromDate 传入1-5号，方法均返回0
     则 fromDate 传入6-12号，方法均返回1
     则 fromDate 传入13-19号，方法均返回2
     ....
     
     */
    //MARK: --日历信息的获取
    
    func calendarInfo(){
        
        let calendar: Foundation.Calendar = Foundation.Calendar.current
        
        //1）获取一个小的单位在一个大的单位里面的序数
        
        let count = (calendar as NSCalendar).ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: Date())
        print("calendarInfo:---\(count)")
    }
    
    
    /*
     
     public func rangeOfUnit(smaller: NSCalendarUnit, inUnit larger: NSCalendarUnit, forDate date: NSDate) -> NSRange
     
     调用这个方法要明确一点，取得的是"范围"而不是"包含"，下面是一些例子：
     
     <1>、小单位是 NSCalendarUnitDay，大单位是 NSCalendarUnitYear，并不是要取这一年包含多少天，而是要取"天"(Day)这个单位
     在这一年(Year)的取值范围。其实不管你提供的日期是多少，返回的值都是"1--31"。
     
     <2>、小单位是 NSCalendarUnitDay，大单位是 NSCalendarUnitMonth。要取得参数时间点所对应的月份下，"天"(Day)的取值范围。
     根据参数时间的月份不同，值也不同。例如2月是1--28、3月是1--31、4月是1--30。
     
     <3>、小单位是 NSCalendarUnitWeekOfMonth / NSCalendarUnitWeekOfYear，大单位是 NSCalendarUnitMonth。要取得参数时间点
     所对应的月份下，"周"(Week)的取值范围。需要注意的是结果会受到 minimumDaysInFirstWeek 属性的影响。在默认
     minimumDaysInFirstWeek 情况下，取得的范围值一般是"1--5"，从日历上可以看出来这个月包含5排，即5个周。
     
     <4>、小单位是 NSCalendarUnitDay，大单位是 NSCalendarUnitWeekOfMonth / NSCalendarUnitWeekOfYear。要取得周所包含
     的"天"(Day)的取值范围。下面是一个示例日历图：
     
     2013年4月
     日   一    二   三   四    五   六
     ---------------------------------
     1    2    3    4    5    6
     7    8    9    10   11   12  13
     14   15   16   17   18   19  20
     21   22   23   24   25   26  27
     28   29   30
     
     在上图的日期条件下，假如提供的参数是4月1日--4月6日，那么对应的 week 就是1(第一个周)，可以看到第一个周包含有6天，
     从1号开始，那么最终得到的范围值为1--6。
     
     假如提供的参数是4月18日，那么对应的 week 是3(第三个周)，第三个周包含有7天，从14号开始，那么最终得到的范围值是14--7。
     
     假如提供的参数是4月30日，那么对应的 week 是5(第五个周)，第五个周只包含3天，从28号开始，那么最终得到的范围值是28--3。
     */
    
    func rangeOfUnit() {
        
        let calendar: Foundation.Calendar = Foundation.Calendar.current
        
        var startDate: Date? = nil
        var intervalCount: TimeInterval = 0
        
//        let bl: Bool = (calendar as NSCalendar).range(of: NSCalendar.Unit.month, start: &startDate, interval: &intervalCount, for: Date())
        print("startDate:\(startDate)---------  intervalCount: \(intervalCount)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

