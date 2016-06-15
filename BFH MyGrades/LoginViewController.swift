//
//  LoginViewController.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 28.02.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var isLoggingIn: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    let login = BFHLogin()

    @IBAction func tappedLogin(sender: AnyObject) {
        isLoggingIn.startAnimating()
        loginButton.enabled = false
        login.login(username.text!, password: password.text!, onLoginSuccessful: {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("ShowSemesterFromLoginView", sender: nil)
                    self.isLoggingIn.stopAnimating()
            });
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        username.text = "mosij1"
        if(login.isLoggedIn){
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("ShowSemesterFromLoginView", sender: nil)
            });
        }
    }

}
