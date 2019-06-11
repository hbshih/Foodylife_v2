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
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var separationLine: UIImageView!
    @IBOutlet weak var vegetableField: UIImageView!
    @IBOutlet weak var proteinField: UIImageView!
    @IBOutlet weak var grainField: UIImageView!
    @IBOutlet weak var fruitField: UIImageView!
    @IBOutlet weak var vegetableLabel: UILabel!
    @IBOutlet weak var dairyField: UIImageView!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var grainLabel: UILabel!
    @IBOutlet weak var fruitLabel: UILabel!
    @IBOutlet weak var dairyLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        dairyField.alpha = 0.25
        dairyLabel.alpha = 0
        vegetableLabel.alpha = 0
        vegetableField.alpha = 0.25
        grainLabel.alpha = 0
        grainField.alpha = 0.25
        proteinLabel.alpha = 0
        proteinField.alpha = 0.25
        fruitLabel.alpha = 0
        fruitField.alpha = 0.25
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
