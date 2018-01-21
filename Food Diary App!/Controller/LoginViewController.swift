//
//  LoginViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {


    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginCoordinator.start()
        print("perform segue")
        performSegue(withIdentifier: "testSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signin()
    {
        print("performing segue")
        //performSegue(withIdentifier: "a", sender: nil)
    }
    
    func alertMessage(title: String, message: String)
    {
        let mes = AlertMessage()
        mes.displayAlert(title: title, message: message, VC: self)
    }
    
    func LogInSuccesful()
    {
      //  var segue = UIStoryboardSegue(identifier: "logInSegue", source: self, destination: homepageViewController)
        performSegue(withIdentifier: "testSegue", sender: nil)
    }

}
