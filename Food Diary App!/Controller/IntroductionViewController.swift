//
//  IntroductionViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Lottie



class IntroductionViewController: UIViewController {
    
    @IBOutlet weak var createAccountOutlet: UIButton!
    @IBOutlet weak var signInOutlet: UIButton!
    @IBOutlet weak var facebookOutlet: UIButton!
    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        facebookOutlet.layer.shadowOpacity = 0.3
        facebookOutlet.layer.shadowColor = UIColor(red: 89.0/255.0, green: 117.0/255.0, blue: 177.0/255.0, alpha: 1).cgColor
        facebookOutlet.layer.shadowOffset = CGSize(width: 15, height: 15)
        facebookOutlet.layer.shadowRadius = 7
        runAnimation()
        checkIfUserLogged()
    }
    
    func checkIfUserLogged()
    {
        let user = Auth.auth().currentUser
        if user != nil
        {
            performSegue(withIdentifier: "showHomepageSegue", sender: nil)
        }
    }
    
    func runAnimation()
    {
        let animation = LOTAnimationView(name:"HomeScreenAni.json")
        animation.frame = CGRect(x: 0, y: 100, width: self.animationView.frame.size.width, height: 250)
        animation.contentMode = .scaleAspectFill
        
        self.view.addSubview(animation)
        
        animation.play { (success) in
            print("The Animation is Done")
        }
        animation.loopAnimation = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLogin(_ sender: Any)
    {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            self.fetchProfile()
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }else
                {
                    print("log in success")
                }
            })
            
        }
    }
    
    func fetchProfile(){
        print("attempt to fetch profile......")
        
        let parameters = ["fields": "email, first_name, last_name"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: {
            connection, result, error -> Void in
            
            if error != nil {
                print("登入失敗")
                print("longinerror =\(error)")
            } else {
                
                if let resultNew = result as? [String:Any]{
                    
                    print("成功登入")
                    
                    let email = resultNew["email"]  as! String
                    print(email)
                    
                    let firstName = resultNew["first_name"] as! String
                    print(firstName)
                    
                    let lastName = resultNew["last_name"] as! String
                    print(lastName)
                    
                }
            }
        })
    }
    
    
}
