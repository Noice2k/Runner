//
//  Calendar.swift
//  Runner
//
//  Created by Igor Sinyakov on 09/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit

open class CalendarDay
{
    
    // MARK : model
    var dayLabel: String
    var weekLebel: String
    var monthLabel: String
    
    var dayData: Date
    var dayOfWeek: Int
    var month : Int
    
    
    
    init(day: Date,dayOfWeek: Int, month : Int)
    {
        let df = DateFormatter()
        df.dateFormat = "dd"
        self.dayLabel = df.string(from: day)
        df.dateFormat = "MMM"
        self.monthLabel = df.string(from: day)
        df.dateFormat = "EEE"
        self.weekLebel = df.string(from: day)
        
        self.dayData = day
        self.dayOfWeek = dayOfWeek
        self.month = month
    }

}


open class CalendarWeek
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
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        formater.timeZone = TimeZone(abbreviation: "GMT")
        
        if let firstdate = formater.date(from: str){
            // first day of weeek in the this year
            let firstweekday = (Foundation.Calendar.current as NSCalendar).component(.weekday, from: firstdate) - 2
            let firstweekid  = (Foundation.Calendar.current as NSCalendar).component(.weekOfYear, from: firstdate)
            
            var currentWeek : CalendarWeek? = nil
            // add all days for current year
            for i in 0...daysInYear-1 {
                // get new day data
                if let newdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: i, to: firstdate, options: []) {
                    // create new week
                    let weekId      = firstweekid + (i+firstweekday) / 7
                    let dayofweek   = (firstweekday + i ) % 7
                    
                    if weekId > weeks.count{
                        currentWeek = CalendarWeek(weekid: weekId);
                        weeks += [currentWeek!]
                    }
                    // get the day attribute
                    let month = (Foundation.Calendar.current as NSCalendar).component(.month, from: newdate)
                    let newday = CalendarDay(day:newdate,dayOfWeek: dayofweek, month: month)
                    currentWeek!.days += [newday]
                }
                
            }
        }
    }
}












