//
//  CalendarTableViewHeaderCell.swift
//  Runner
//
//  Created by Igor Sinyakov on 14/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit

class CalendarTableViewHeaderCell: UITableViewCell
{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var weekCaption: UILabel!
    
    @IBOutlet weak var runCaption: UILabel!
    @IBOutlet weak var timeCaption: UILabel!
    @IBOutlet weak var distCaption: UILabel!
    @IBOutlet weak var collapsButton: UIButton!
    
    // MARK: model
    var week : CalendarWeek? {
        didSet { UpdateUI()}
    }
    
    func changeExpandStyle(){
        let imagename = week!.expandAll ? "ArrowUp" : "ArrowDown"
        let image = UIImage(named: imagename)
        collapsButton.setImage(image, for: .normal)
        
    }
    
    // MARK: implementation
    private func UpdateUI() {
        if week != nil {
            runCaption!.text = "\(week!.realRun)/\(week!.plannedRun) run"
            timeCaption!.text = "\(week!.totalTime.ToTime())"
            distCaption!.text = "\(week!.runDist.to2dig()) km"
            changeExpandStyle()
        } else {
            runCaption!.text = "0/0 run"
            timeCaption!.text = "00:00:00"
            distCaption!.text = "0 km"
        }
    }
}
