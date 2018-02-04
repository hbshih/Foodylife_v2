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

class OnBoardingViewController: UIViewController {

    var defaults = UserDefaultsHandler()
    var swiftyOnboard: SwiftyOnboard!
    let colors:[UIColor] = [#colorLiteral(red: 1, green: 0.7150892615, blue: 0, alpha: 1),#colorLiteral(red: 0.5621222854, green: 0.7577332258, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.6476797462, blue: 0, alpha: 1),#colorLiteral(red: 0.2067656815, green: 0.8225870728, blue: 1, alpha: 1)]
    var titleArray: [String] = ["Welcome to FoodyLife!", "Make food tracking easy", "Balance your diet", "Become Healthier!"]
    var subTitleArray: [String] = ["Confess lets you anonymously\n send confessions to your friends\n and receive confessions from them.", "All confessions sent are\n anonymous. Your friends will only\n know that it came from one of\n their facebook friends.", "Be nice to your friends.\n Send them confessions that\n will make them smile :)","Be nice to your friends.\n Send them confessions that\n will make them smile :)"]
    
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
        if defaults.getOnboardingStatus() is Bool
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
        /*
        if ShowOnBoard == nil || ShowOnBoard == false
        {
            gradient()
            UIApplication.shared.statusBarStyle = .lightContent
            swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
            view.addSubview(swiftyOnboard)
            swiftyOnboard.dataSource = self as SwiftyOnboardDataSource
            swiftyOnboard.delegate = self as? SwiftyOnboardDelegate
        }else
        {
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.5, execute:{self.performSegue(withIdentifier: "getStartedSegue", sender: self)})
        }*/
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
            print("GET STARTED!")
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
        let buttonOne = CancelButton(title: "DECIDE LATER", height: 60) {
            self.performSegue(withIdentifier: "getStartedSegue", sender: nil)
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "LET'S START", height: 60) {
            self.defaults.setOnboardingStatus(status: true)
            self.defaults.setPlanStandard(value: selectPlanVC.getSelectedOption())
            print("Choosed plan \(selectPlanVC.getSelectedOption())")
            self.performSegue(withIdentifier: "getStartedSegue", sender: nil)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
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
        print(Int(currentPage))
        overlay.continueButton.tag = Int(position)
        
        if currentPage == 0.0 || currentPage == 1.0 || currentPage == 2.0{
            overlay.continueButton.setTitle("Continue", for: .normal)
            overlay.skipButton.setTitle("Skip", for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("Get Started!", for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}


