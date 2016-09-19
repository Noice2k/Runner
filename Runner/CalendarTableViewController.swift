//
//  CalendarTableViewController.swift
//  Runner
//
//  Created by Igor Sinyakov on 09/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit
import Firebase

class CalendarTableViewController: UITableViewController {
    
    fileprivate var _myRootRef : FIRDatabaseReference? = nil
    var myRootRef : FIRDatabaseReference {
        get{
            if _myRootRef == nil {
               _myRootRef = FIRDatabase.database().reference()
                
                // debug login
                FIRAuth.auth()?.signIn(withEmail: "shumaher2000@mail.ru", password: "test1234")
                { (user, error) in
                    // ...
                }
            }
            return _myRootRef!
        }
    }
    
    
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
    //var calendar = Calendar(count: 10)
    
    // initilize calendar
    fileprivate func InitCalendar()
    {
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData{
                let uid = profile.uid
                let userref = myRootRef.child("Noice")
                userref.setValue([uid,"Do you have data? you will love Firebase"])
                
            }
            
        }
        
        
        
        myRootRef.observe(.value, with: {
            shapshot in
            print("\(shapshot.key)->\(shapshot.value)")
        })
        
    }
    
    // MARK: Constants
    let cellDayIdentificator = "DayTableViewCell"
    
    // MARK: Navigtion
    
    // Number of section, current - 0
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendar.days.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellDayIdentificator) as! CalendarTableViewCell
        let day = calendar.days[indexPath.row]
        
        cell.dateLabel.text = day.day
        return cell
    }
    */
}
        
        
