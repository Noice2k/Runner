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
    fileprivate func InitCalandar() {
        // create the calendar
        calendar = Calendar(year: Foundation.Calendar.current.currentYear)
        // set the current day as visible day
        let indexpath = IndexPath(row: 0, section: Foundation.Calendar.current.currentWeek-1)
        calendarView.selectRow(at: indexpath, animated: true, scrollPosition: .top)
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
    
    fileprivate struct Constants {
        static let cellDayIdentificator = "Calendar Day Cell"
        static let cellWeekIdentificator = "Calendar Week Cell"
        static let cellEditSegue = "Edit Day"
    }
    
    @IBAction func TapToShowAndEditDay(_ sender: AnyObject) {
    
    }
    
    // MARK: model
    var calendar : Calendar?
    
    
    // Number of section, current
    func numberOfSections(in tableView: UITableView) -> Int {
        return calendar!.weeks.count
    }
    
    // number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return calendar!.weeks[section].days.count
    }
    
    // get day cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellDayIdentificator) as! CalendarTableViewCell
        let day = calendar!.weeks[(indexPath as NSIndexPath).section].days[(indexPath as NSIndexPath).row]
        
        cell.day = day
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.ViewTapped))
        cell.addGestureRecognizer(tap)
        
        return cell
    }
    
    //
    @objc func ViewTapped(sender: UITapGestureRecognizer)  {
       
        let location : CGPoint = sender.location(in: self.calendarView)
        let indexpath : IndexPath? = self.calendarView.indexPathForRow(at: location)
        let cell: CalendarTableViewCell = self.calendarView.cellForRow(at: indexpath!) as! CalendarTableViewCell
        performSegue(withIdentifier: Constants.cellEditSegue, sender: cell)
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let distination = segue.destination as? EditDayViewController
        if  let source = sender as? CalendarTableViewCell {
            if segue.identifier == Constants.cellEditSegue
            {
                distination?.day = source.day
                
            }
        }
        
    }
    
    
    // get week header cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellWeekIdentificator) as! CalendarTableViewHeaderCell
        let week = calendar!.weeks[section]
        cell.weekCaption.text  = "Week #\(week.weekId)"
        
        return cell
    }
 
}

// return current year
extension Foundation.Calendar{
    var currentYear : Int {
        get {
            let date = Date()
            let year = (Foundation.Calendar.current as NSCalendar).component(.year,from: date)
            return year
        }
    }
    var currentWeek : Int {
        get {
            let date = Date()
            let weak  = (Foundation.Calendar.current as NSCalendar).component(.weekOfYear, from: date)
            return weak
        }
    }
}
