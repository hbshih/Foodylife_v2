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
        
        if circularSlider.angle > 90
        {
            /*
            let colorBlue = UIColor(red: 134, green: 214, blue: 247, alpha: 1)
            let colorBlueHue = UIColor(red: 211, green: 242, blue: 255, alpha: 1)
            circularSlider.set(colors: color.blue)
            circularSlider.trackColor = colorBlueHue
 */
        }
        
        var currentAngle = circularSlider.angle
        var newAngle = currentAngle + 10
        return newAngle
    }
}
