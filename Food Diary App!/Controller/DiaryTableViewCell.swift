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
    @IBOutlet weak var separationLine: UIImageView!
    @IBOutlet weak var vegetableField: UIImageView!
    @IBOutlet weak var proteinField: UIImageView!
    @IBOutlet weak var grainField: UIImageView!
    @IBOutlet weak var fruitField: UIImageView!
    @IBOutlet weak var diaryField: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vegetableField.alpha = 0.25
        diaryField.alpha = 0.25
        fruitField.alpha = 0.25
        proteinField.alpha = 0.25
        grainField.alpha = 0.25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
