//
//  IntroductionViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {

    @IBOutlet weak var createAccountOutlet: UIButton!
    @IBOutlet weak var signInOutlet: UIButton!
    @IBOutlet weak var facebookOutlet: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        facebookOutlet.layer.shadowOpacity = 0.3
        facebookOutlet.layer.shadowColor = UIColor(red: 89.0/255.0, green: 117.0/255.0, blue: 177.0/255.0, alpha: 1).cgColor
        facebookOutlet.layer.shadowOffset = CGSize(width: 15, height: 15)
        facebookOutlet.layer.shadowRadius = 7
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
