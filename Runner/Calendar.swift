//
//  Calendar.swift
//  Runner
//
//  Created by Igor Sinyakov on 09/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit

public class CalendarDay
{
    
    // MARK : model
    var dayLabel: String
    var weekLebel: String
    var monthLabel: String
    
    var dayData: NSDate
    var dayOfWeek: Int
    var month : Int
    
    
    
    init(day: NSDate,dayOfWeek: Int, month : Int)
    {
        let df = NSDateFormatter()
        df.dateFormat = "dd"
        self.dayLabel = df.stringFromDate(day)
        df.dateFormat = "MMM"
        self.monthLabel = df.stringFromDate(day)
        df.dateFormat = "EEE"
        self.weekLebel = df.stringFromDate(day)
        self.dayData = day
        self.dayOfWeek = dayOfWeek
        self.month = month
    }

}


public class CalendarWeek
{
    //MARK : model
    var days = [CalendarDay]()
    var weekId :  Int
    
    init(weekid : Int){
        self.weekId = weekid
    }
    
    
}

// the caleandr is an array of weeks in the year

class Calendar
{
    //MARK : Model
    
    var weeks =  [CalendarWeek]()
    // the count days in current year
    var daysInYear : Int
    
    //MARK : Initilization
    init (year : Int ){
        
        daysInYear = (year % 4) > 0 ? 365 : 366
        let str = "\(year)-01-01"
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        formater.timeZone = NSTimeZone(abbreviation: "GMT")
        
        if let firstdate = formater.dateFromString(str){
            // add all days for current year
            for i in 0...daysInYear-1 {
                // get new day data
                if let newdate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: i, toDate: firstdate, options: []) {
                    // create new week
                    var weekId = NSCalendar.currentCalendar().component(.WeekOfYear, fromDate: newdate)
                    let dayofweek = NSCalendar.currentCalendar().component(.Weekday, fromDate: newdate)
                    
                    if dayofweek == 1 {
                        weekId -= 1
                    }
                    if weekId > weeks.count{
                        let currentWeek = CalendarWeek(weekid: weekId);
                        weeks += [currentWeek]
                    }
                    // get the day attribute
                    let month = NSCalendar.currentCalendar().component(.Month, fromDate: newdate)
                    let newday = CalendarDay(day:newdate,dayOfWeek: dayofweek, month: month)
                    weeks[weekId].days += [newday]
                }
                
            }
        }
    }
}












