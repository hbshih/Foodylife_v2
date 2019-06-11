//
//  OnBoardingViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 03/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import SwiftyOnboard
import PopupDialog
import SCLAlertView
import FirebaseAnalytics

class OnBoardingViewController: UIViewController {
    
    var defaults = UserDefaultsHandler()
    var swiftyOnboard: SwiftyOnboard!
    let colors:[UIColor] = [#colorLiteral(red: 0.9725490196, green: 0.6705882353, blue: 0.2745098039, alpha: 1),#colorLiteral(red: 0.9921568627, green: 0.5215686275, blue: 0.3490196078, alpha: 1),#colorLiteral(red: 0.9764705882, green: 0.4470588235, blue: 0.4039215686, alpha: 1),#colorLiteral(red: 0.5621222854, green: 0.7577332258, blue: 0, alpha: 1)]
    
    var titleArray: [String] = ["Welcome to FoodyLife!".localized(), NSLocalizedString("Track your food", comment: ""), NSLocalizedString("Balance the five food groups", comment: ""),NSLocalizedString("Become healthier and happier!", comment: "")]
    
    var subTitleArray: [String] = [
        NSLocalizedString("Understanding more about your diet helps you eat right and live a healthier life!", comment: ""),
        NSLocalizedString("Take a picture and record your food with a simple interface -  keeping track of what you eat has never been easier.", comment: ""),
        NSLocalizedString("Have you eaten your vegetables today? Check the Balance Board to review your progress with the 5 food groups and get all nutrition needed every day.", comment: ""),
        NSLocalizedString("Transform the way you eat without the focus on calorie counting! Become a Foody with a balanced diet and a balanced life!.", comment: "")]
    
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.getOnboardingStatus() == true
        {
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.5, execute:{self.performSegue(withIdentifier: "getStartedSegue", sender: self)})
        }else
        {
            gradient()
            UIApplication.shared.statusBarStyle = .lightContent
            swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
            view.addSubview(swiftyOnboard)
            swiftyOnboard.dataSource = self as SwiftyOnboardDataSource
            swiftyOnboard.delegate = self as? SwiftyOnboardDelegate
        }
    }
    
    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 3, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
        if index == 3
        {
            selectPlan()
            //   performSegue(withIdentifier: "getStartedSegue", sender: nil)
        }
    }
    
    func selectPlan()
    {
        // Create a custom view controller
        let selectPlanVC = SelectPlanViewController(nibName: "SelectPlanViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: selectPlanVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        
        let buttonOne = CancelButton(title: NSLocalizedString("DECIDE LATER", comment: ""), height: 60) {
            self.defaults.setPlanStandard(value: numberOfServes().getCustom())
            let appearance = SCLAlertView.SCLAppearance(
                //kCircleIconHeight: 55.0
                kTitleFont: UIFont(name: "HelveticaNeue-Medium", size: 18)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 16)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 18)!,
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            let icon = UIImage(named:"Alert_Yellow.png")
            let color = UIColor.orange
            alert.addButton(NSLocalizedString("Ready to explore", comment: ""), target: self, selector: #selector(self.segueToNotiAuthorization))
            _ = alert.showCustom(NSLocalizedString("Undecided plan?", comment: ""), subTitle: NSLocalizedString("Your diet plan will be set to custom now, you can change the plan in the setting page! See you there!", comment: ""), color: color, icon: icon!)
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: NSLocalizedString("LET'S START", comment: ""), height: 60) {
            self.defaults.setPlanStandard(value: selectPlanVC.getSelectedOption())
            if selectPlanVC.getSelectedOption() == numberOfServes().getCustom()
            {
                //print("Customize")
                self.segueToCustomize()
                //                self.defaults.setPlanStandard(value: numberOfServes().getCustom())
                //                let appearance = SCLAlertView.SCLAppearance(
                //                    //kCircleIconHeight: 55.0
                //                    kTitleFont: UIFont(name: "HelveticaNeue-Medium", size: 18)!,
                //                    kTextFont: UIFont(name: "HelveticaNeue", size: 16)!,
                //                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 18)!,
                //                    showCloseButton: false
                //                )
                //                let alert = SCLAlertView(appearance: appearance)
                //                let icon = UIImage(named:"Alert_Yellow.png")
                //                let color = UIColor.orange
                //                alert.addButton("Ready to explore", target: self, selector: #selector(self.segueToHomeScreen))
                //                _ = alert.showCustom("Undecided plan?", subTitle: "Your diet plan will be set to custom now, you can change the plan in the setting page! See you there!", color: color, icon: icon!)
            }else
            {
                Analytics.logEvent("Chose_Gender_Standard", parameters: nil)
                self.defaults.setOnboardingStatus(status: true)
                //print("Customize2")
                self.segueToNotiAuthorization()
            }
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion:nil)
    }
    
    @objc func segueToNotiAuthorization()
    {
        performSegue(withIdentifier: "notificationAuthorizationSegue", sender: nil)
    }
    
    @objc func segueToHomeScreen()
    {
        performSegue(withIdentifier: "getStartedSegue", sender: nil)
    }
    
    @objc func segueToCustomize()
    {
        performSegue(withIdentifier: "customizeSegue", sender: nil)
    }
}


extension OnBoardingViewController: SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        //Number of pages in the onboarding:
        return 4
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        //Return the background color for the page at index:
        return colors[index]
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        //Set the image on the page:
        view.imageView.image = UIImage(named: "onboard\(index)")
        
        //Set the font and color for the labels:
        view.title.font = UIFont(name: "Montserrat-Bold", size: 22)
        view.subTitle.font = UIFont(name: "Montserrat-Medium", size: 16)
        
        //Set the text in the page:
        view.title.text = titleArray[index]
        view.subTitle.text = subTitleArray[index]
        
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        //Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.titleLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.continueButton.tag = Int(position)
        
        if currentPage == 0.0 || currentPage == 1.0 || currentPage == 2.0{
            overlay.continueButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
            overlay.skipButton.setTitle(NSLocalizedString("Skip", comment: ""), for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle(NSLocalizedString("Get Started!", comment: ""), for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}


