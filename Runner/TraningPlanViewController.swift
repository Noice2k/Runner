//
//  TraningPlanViewController.swift
//  
//
//  Created by Igor Sinyakov on 13/09/16.
//
//

import UIKit

class TraningPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    override func viewDidLoad() {
        super.viewDidLoad()
        InitCalandar()
    }
    
    // initilaze the calendar object
    private func InitCalandar() {
        // create the calendar
        calendar = Calendar(year: NSCalendar.currentCalendar().currentYear)
        // set the current day as visible day
        let indexpath = NSIndexPath(forRow: 0, inSection: NSCalendar.currentCalendar().currentWeek-1)
        calendarView.selectRowAtIndexPath(indexpath, animated: true, scrollPosition: .Top)
    }
    
    
    @IBOutlet weak var calendarView: UITableView! {
        didSet {
            calendarView.delegate = self
            calendarView.dataSource = self
            calendarView.rowHeight = 50
            calendarView.sectionHeaderHeight = 35
        }
    }
    
    // MARK: Constants
    
    private struct CellNames {
        static let cellDayIdentificator = "Calendar Day Cell"
        static let cellWeekIdentificator = "Calendar Week Cell"
    }
    
    @IBAction func TapToShowAndEditDay(sender: AnyObject) {
    
    }
    
    // MARK: model
    var calendar : Calendar?
    
    
    // Number of section, current
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return calendar!.weeks.count
    }
    
    // number of rows in section
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return calendar!.weeks[section].days.count
    }
    
    // get day cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellNames.cellDayIdentificator) as! CalendarTableViewCell
        let day = calendar!.weeks[indexPath.section].days[indexPath.row]
        
        cell.dayLabel.text = day.dayLabel
        cell.weekLabel.text = day.weekLebel
        cell.monthLabel.text = day.monthLabel
        return cell
    }
    
    // get week header cell
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellNames.cellWeekIdentificator) as! CalendarTableViewHeaderCell
        let week = calendar!.weeks[section]
        cell.weekCaption.text  = "Week #\(week.weekId)"
        
        return cell
    }
 
}

// return current year
extension NSCalendar{
    var currentYear : Int {
        get {
            let date = NSDate()
            let year = NSCalendar.currentCalendar().component(.Year,fromDate: date)
            return year
        }
    }
    var currentWeek : Int {
        get {
            let date = NSDate()
            let weak  = NSCalendar.currentCalendar().component(.WeekOfYear, fromDate: date)
            return weak
        }
    }
}