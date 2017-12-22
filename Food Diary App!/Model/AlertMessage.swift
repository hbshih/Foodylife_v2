//
//  AlertMessage.swift
//  Food Diary App!
//
//  Created by Ben Shih on 19/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import Foundation
import UIKit

struct AlertMessage
{
    func displayAlert(title: String, message: String, VC: UIViewController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        VC.present(alertController, animated: true, completion: nil)
    }
}
