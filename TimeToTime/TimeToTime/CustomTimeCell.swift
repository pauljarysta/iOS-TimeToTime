//
//  CustomTimeCell.swift
//  TimeToTime
//
//  Created by Paul Jarysta on 14/11/2015.
//  Copyright © 2015 Paul Jarysta. All rights reserved.
//

import UIKit

class CustomTimeCell: UITableViewCell {

	@IBOutlet var lbHour: UILabel!
	@IBOutlet var lbDate: UILabel!
	@IBOutlet var lbTimezone: UILabel!
	@IBOutlet var lbLocality: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
