//
//  CalendarTableViewController.swift
//  Runner
//
//  Created by Igor Sinyakov on 09/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit

class CalendarTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        InitCalendar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Properties
    var calendar = Calendar(count: 10)
    
    // initilize calendar
    private func InitCalendar()
    {
        
    }
    
    // MARK: Constants
    let cellDayIdentificator = "DayTableViewCell"
    
    // MARK: Navigtion
    
    // Number of section, current - 0
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendar.days.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellDayIdentificator) as! CalendarTableViewCell
        let day = calendar.days[indexPath.row]
        
        cell.dateLabel.text = day.day
        return cell
    }
    
}
        
        