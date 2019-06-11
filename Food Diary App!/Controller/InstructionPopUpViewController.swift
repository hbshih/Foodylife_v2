//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit


class InstructionPopUpViewController: UIViewController {
    
    @IBOutlet weak var infoGraph: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = NSLocale.current.languageCode
        if (locale! == "zh")
        {
            infoGraph.image = #imageLiteral(resourceName: "zh_Image_EatWellGuide")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

