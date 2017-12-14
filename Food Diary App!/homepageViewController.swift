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
        print(circularSlider.angle)
        if circularSlider.angle >= 360
        {
            print("----- Start Again -----")
            return 0
        }
        // Red -- Bad Health
        if circularSlider.angle >= 0 && circularSlider.angle <= 30
        {
            circularSlider.set(colors: UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0))
            circularSlider.trackColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
        }// Yellow -- Neutral
        else if circularSlider.angle > 30 && circularSlider.angle <= 180
        {
            circularSlider.set(colors: UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0))
            circularSlider.trackColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:0.2)
        }
            // Blue -- Good
        else if circularSlider.angle > 180 && circularSlider.angle <= 330
        {
            circularSlider.set(colors:UIColor(red:0.39, green:0.82, blue:0.99, alpha:1.0))
            circularSlider.trackColor = UIColor(red:0.39, green:0.82, blue:0.99, alpha:0.2)
        }else if circularSlider.angle > 330 && circularSlider.angle < 360
        {
            circularSlider.set(colors: UIColor(red:0.60, green:0.80, blue:0.29, alpha:1.0))
            circularSlider.trackColor = UIColor(red:0.60, green:0.80, blue:0.29, alpha:0.2)
        }
        
        let currentAngle = circularSlider.angle
        return currentAngle + 10
    }
}
