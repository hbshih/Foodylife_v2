//
//  DiaryTableViewCell.swift
//  Food Diary App!
//
//  Created by Ben Shih on 28/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {


    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var foodTypeIcon: UIImageView!
    @IBOutlet weak var foodType: UILabel!
    @IBOutlet weak var separationLine: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
