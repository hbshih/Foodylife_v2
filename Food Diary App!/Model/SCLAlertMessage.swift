//
//  SCLAlertMessage.swift
//  Food Diary App!
//
//  Created by Ben Shih on 28/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import SCLAlertView
import UIKit

struct SCLAlertMessage
{
    let title: String
    let message: String
    
    
    func showMessage()
    {
        let appearance = SCLAlertView.SCLAppearance(
            //kCircleIconHeight: 55.0
            kTitleFont: UIFont(name: "HelveticaNeue-Medium", size: 18)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 16)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 18)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let icon = UIImage(named:"Alert_Yellow.png")
        let color = UIColor.orange
        _ = alert.showCustom(title, subTitle: message, color: color, icon: icon!)
    }
    
    
}
