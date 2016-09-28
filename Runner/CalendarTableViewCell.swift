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
    @IBOutlet weak var trainDistanceAndType: UILabel!
    @IBOutlet weak var trainTypeAndSpeed: UILabel!
    var day : CalendarDay? {
        didSet {
           UpdateUI()
        }
    }
    
    private func  UpdateUI()  {
        dayLabel.text = day!.dayLabel
        weekLabel.text = day!.weekLebel
        monthLabel.text = day!.monthLabel
        trainTypeAndSpeed.text = ""
        trainDistanceAndType.text = Traning.trannignTypeConstants[0]
    
        if day!.training != nil {
            let dist = day!.training!.distance.to2dig()
            let type =  Traning.trannignTypeConstants[day!.training!.type.rawValue]
            trainDistanceAndType.text = "\(dist)km"
            var speed : String
            if day!.training?.distance != 0 {
                speed  = Traning.getTimePerKmSped(time: day!.training!.time, dis: day!.training!.distance)
            } else { speed = ""}

            trainTypeAndSpeed.text = "\(type)\r\n\(speed)"
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  //      let tap = UITapGestureRecognizer(target: self, action: #selector(self.ViewTapped))
   //     addGestureRecognizer(tap)
    }
}
