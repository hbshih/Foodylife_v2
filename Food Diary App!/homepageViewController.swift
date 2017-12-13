//
//  homepageViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 13/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit

class homepageViewController: UIViewController {

    @IBOutlet weak var circularSlider: KDCircularProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circularSlider.startAngle = -90.0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: Any)
    {

                let newAngleView = newAngle()
                print(newAngleView)
                circularSlider.animate(toAngle: newAngleView, duration: 0.5, completion: nil)
        
    }
    
    func newAngle() -> Double
    {
        if circularSlider.angle == 360
        {
            circularSlider.angle = 0
            
        }
        var currentAngle = circularSlider.angle
        var newAngle = currentAngle + 10
        return newAngle
    }
}
