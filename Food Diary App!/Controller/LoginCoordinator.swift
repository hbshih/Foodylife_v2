//
//  LoginCoordinator.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import ILLoginKit
import FirebaseAuth

class LoginCoordinator: ILLoginKit.LoginCoordinator {
    // MARK: - LoginCoordinator
    let lg = LoginViewController()
    
    override func start() {
        super.start()
        configureAppearance()
    }
    
    override func finish() {
        super.finish()
    }
    
    // MARK: - Setup
    
    func configureAppearance() {
        // Customize LoginKit. All properties have defaults, only set the ones you want.
        
        // Customize the look with background & logo images
        backgroundImage = #imageLiteral(resourceName: "Background-3")
         mainLogoImage = #imageLiteral(resourceName: "Logo_Foody Life")
        // secondaryLogoImage =
        
        // Change colors
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Sign In"
        signupButtonText = "Create Account"
        facebookButtonText = "Login with Facebook"
        forgotPasswordButtonText = "Forgot password?"
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Username"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Password!"
        repeatPasswordPlaceholder = "Confirm password!"
    }
    
    // MARK: - Completion Callbacks
    
    override func login(email: String, password: String)
    {
        // Handle login via your API
        print("Login with: email =\(email) password = \(password)")
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil
            {
                self.lg.alertMessage(title: "Error", message:  error!.localizedDescription)
            }else
            {
                print("Log on success")
                self.lg.LogInSuccesful()
            }
        })
    }
    
    
    
    // Handle signup via your API
    override func signup(name: String, email: String, password: String)
    {
        lg.signin()
        print("Signup with: name = \(name) email =\(email) password = \(password)")
    }
    
    override func enterWithFacebook(profile: FacebookProfile) {
        // Handle Facebook login/signup via your API
        print("Login/Signup via Facebook with: FB profile =\(profile)")
        
    }
    
    override func recoverPassword(email: String) {
        // Handle password recovery via your API
        print("Recover password with: email =\(email)")
    }

}
