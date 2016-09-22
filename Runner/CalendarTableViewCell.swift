//
//  CalendarTableViewCell.swift
//  Runner
//
//  Created by Igor Sinyakov on 09/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    //MARK: Model
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
   
    var day : CalendarDay? {
        willSet {
            if newValue != nil {
                dayLabel.text = newValue!.dayLabel
                weekLabel.text = newValue!.weekLebel
                monthLabel.text = newValue!.monthLabel
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  //      let tap = UITapGestureRecognizer(target: self, action: #selector(self.ViewTapped))
   //     addGestureRecognizer(tap)
    }
    
    //@objc func ViewTapped(sender: UITapGestureRecognizer)  {
  //
//        perfomseg
  //      print("Tap")
   // }
    
    
}
