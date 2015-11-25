//
//  CustomSearchCell.swift
//  TimeToTime
//
//  Created by Paul Jarysta on 31/10/2015.
//  Copyright © 2015 Paul Jarysta. All rights reserved.
//

import UIKit

class CustomSearchCell: UITableViewCell {
	
	@IBOutlet var lbName: UILabel?
	@IBOutlet var lbTimezone: UILabel?
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
}
