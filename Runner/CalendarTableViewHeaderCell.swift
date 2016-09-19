//
//  CalendarTableViewHeaderCell.swift
//  Runner
//
//  Created by Igor Sinyakov on 14/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit

class CalendarTableViewHeaderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var weekCaption: UILabel!
}
