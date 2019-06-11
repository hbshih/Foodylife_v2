//
//  DayViewDairyTableViewCell.swift
//  Food Diary App!
//
//  Created by Ben Shih on 31/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit

class DayViewDairyTableViewCell: UITableViewCell {

    @IBOutlet weak var metalPrize: UIImageView!
    @IBOutlet weak var metalPrize_2: UIImageView!
    @IBOutlet weak var metalPrize3: UIImageView!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var vegetableInfo: UILabel!
    @IBOutlet weak var proteinInfo: UILabel!
    @IBOutlet weak var grainInfo: UILabel!
    @IBOutlet weak var fruitInfo: UILabel!
    @IBOutlet weak var dairyInfo: UILabel!
    @IBOutlet weak var colourIndicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
