//
//  TraningPlanViewController.swift
//  
//
//  Created by Igor Sinyakov on 13/09/16.
//
//

import UIKit
import Firebase

class TraningPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK - Firebase 
    fileprivate var _myRootRef : FIRDatabaseReference? = nil
    var myRootRef : FIRDatabaseReference {
        get{
            if _myRootRef == nil {
                _myRootRef = FIRDatabase.database().reference().child("currentuser")
                
                // debug login
                FIRAuth.auth()?.signIn(withEmail: "shumaher2000@mail.ru", password: "test1234")
                { (user, error) in
                    // ...
                   // self._myRootRef = self._myRootRef?.child(user!.uid)
                }
            }
            return _myRootRef!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitCalandar()
        
    }
    
    
    @IBOutlet weak var yearRunTime: UILabel!
    @IBOutlet weak var yearRunCount: UILabel!
    @IBOutlet weak var yearDistanceLabel: UILabel!
    var overlay : GrayActivityIndicator?
    
    // initilaze the calendar object
    fileprivate func InitCalandar() {
      
        // show overlapped activity indicator
        overlay = GrayActivityIndicator(frame: view.frame)
        view.addSubview(overlay!)
        overlay!.Show()
        
        // create the calendar
        calendar = Calendar(year: Foundation.Calendar.current.currentYear)
        // set expand style for -2..+2 weeks
        let currentweekid = Foundation.Calendar.current.currentWeek
        for i in 0...calendar!.weeks.count-1 {
            if i < currentweekid-2 {
                calendar!.weeks[i].expandAll = false
            } else if i > currentweekid+1 {
                calendar!.weeks[i].expandAll = false
            } else {
                calendar!.weeks[i].expandAll = true
            }
        }
        
        // set the current day as visible day
        let indexpath = IndexPath(row: 0, section: currentweekid-1)
        calendarView.selectRow(at: indexpath, animated: true, scrollPosition: .top)
        
        // load data from database
        myRootRef.observe(FIRDataEventType.value, with: { (snapshot) in
            if let year = snapshot.value as? [String:AnyObject] {
                if let days = year["2016"] as? [String:AnyObject] {
                    for (key,day) in days {
                        if let currentday = self.calendar?.allDays[key] {
                            if let training = day as? [String:AnyObject] {
                                currentday.training = Traning(dictFromFB: training)
                            }
                        }
                    }
                }
            }
            // Run closure in the main quieq
            DispatchQueue.main.async {
                // update calendar value
                self.updateUI()
                // remove overlay view with activity indicator
                self.overlay?.removeFromSuperview()
            }
        })
    }
    
    @IBAction func CollapsWeek(_ sender: UIButton) {
        if let cell = sender.superview?.superview?.superview as? CalendarTableViewHeaderCell {
            cell.week!.expandAll = !cell.week!.expandAll
            cell.changeExpandStyle()
            calendarView.reloadData()
        }

    }
    
    @IBOutlet weak var calendarView: UITableView! {
        didSet {
            calendarView.delegate = self
            calendarView.dataSource = self
            calendarView.rowHeight = 50
            calendarView.sectionHeaderHeight = 50
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
    
    func updateUI(){
        calendar?.updateStatistic()
        yearDistanceLabel?.text = "\(calendar!.runDistance.to2dig())/\(calendar!.totalDistance.to2dig()) km"
        yearRunCount?.text = "\(calendar!.runCount) run/\(calendar!.totalRunCount)"
        yearRunTime?.text = "\(calendar!.runTime.ToTime())"
        calendarView.reloadData()
        
    }
    
    
    // Number of section, current
    func numberOfSections(in tableView: UITableView) -> Int {
        return calendar!.weeks.count
    }
    
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    // number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if calendar!.weeks[section].expandAll == false{
            return 0
        }
        
        return calendar!.weeks[section].days.count
    }
    
    // get day cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellDayIdentificator) as! CalendarTableViewCell
        let day = calendar!.weeks[(indexPath as NSIndexPath).section].days[(indexPath as NSIndexPath).row]
        cell.day = day
        return cell
    }
    
    @IBAction func tapPlanButton(_ sender: UIButton) {
     /*   let source = sender.superview?.superview
        if let cell = source as? CalendarTableViewCell {
            
            performSegue(withIdentifier: Constants.cellEditSegue, sender: cell)

        }
 */
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let btn = sender as? UIButton {
            if let cell = btn.superview?.superview as? CalendarTableViewCell {
                let distination = segue.destination as? EditDayViewController
                distination?.day = cell.day
                // set the root of day
                let yearstr = "\(Foundation.Calendar.current.currentYear)"
                var path = "\(yearstr)/\(cell.day!.path)"
                distination?.dayRootRef = myRootRef.child(path)
                path = "d"
            }
        }
    
    }
    
    // get week header cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellWeekIdentificator) as! CalendarTableViewHeaderCell
        let week = calendar!.weeks[section]
        cell.weekCaption.text  = "Week #\(week.weekId)"
        cell.week = week
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

extension Int {
    func ToTime() -> String{
        let hours = self / 3600
        let min = (self/60) % 60
        let sec = self % 60
        return "\(hours.to2dig()):\(min.to2dig()):\(sec.to2dig())"
    }
}

