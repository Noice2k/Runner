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
    var day: String 
    
    init(day: String){
        self.day = day
    }
    init(day: NSDate)
    {
        let df = NSDateFormatter()
        df.dateFormat = "dd::MM"
        self.day = df.stringFromDate(day)
    }

}

class Calendar
{
    //MARK : Model
    private var _days : [CalendarDay]
    
    var days: [CalendarDay] {
        get { return _days}
    }
    
    //MARK : Initilization
   
    
    init(daycount: Int, begindate: NSDate) {
        _days = [CalendarDay]()
        for index in 1...daycount {
            
            let date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: index, toDate: NSDate(),options: [])
            let newday = CalendarDay(day: date!)
            
            // let newday = CalendarDay(day: "\(index)")
            _days += [newday]
        }
    }
    
    
    convenience init(count : Int)
    {
        self.init(daycount: count, begindate: NSDate())
    }
    
    
    
    
}

