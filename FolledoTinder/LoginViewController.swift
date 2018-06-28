//
//  LoginViewController.swift
//  FolledoTinder
//
//  Created by Samuel Folledo on 6/25/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

//1 Setting Up Parse Server
//2 Dragging Objects
//3 Login & Signup
//4 Adding User Details
//5 Adding Users
//6 Swiping Users
//7 Location and Matches

import UIKit
import Parse

class LoginViewController: UIViewController { //3
    
    @IBOutlet weak var errorLabel: UILabel! //3
    @IBOutlet weak var usernameTextField: UITextField! //3
    @IBOutlet weak var passwordTextField: UITextField! //3
    @IBOutlet weak var loginSignupButton: UIButton! //3
    @IBOutlet weak var changeLoginSignupButton: UIButton! //3
    
    var signUpMode = true //3
    
    override func viewDidLoad() { //3
        super.viewDidLoad() //3
        
        errorLabel.isHidden = true //3
    }

    
//loginSignupButton Tapped
    @IBAction func loginSignupButtonTapped(_ sender: Any) { //3 //12mins
        if signUpMode { //3
            let user = PFUser() //3
            user.username = usernameTextField.text //3
            user.password = passwordTextField.text //3
            
            user.signUpInBackground { (success, error) in //3
                 //3//now we check if everything is okay 13 mins
                if error != nil { //3
                    var errorMessage = "Sign Up Failed - Try Again" //3
                    if let newError = error as NSError? { //3//15mins if error can be casted to an NSError which it shoul be able to
                        if let detailError = newError.userInfo["error"] as? String { //3
                            errorMessage = detailError //3
                        } //3
                        self.errorLabel.isHidden = false //3
                        self.errorLabel.text = errorMessage //3
                    } else { //3
                        print("Sign Up Successful") //3
                        self.performSegue(withIdentifier: "updateSegue", sender: nil) //4 //29mins if signup was successful, then let user update their info
                    } //3
                } //3
            } //3
            
        } else { //3 //21mins else log in
            
            if let username = usernameTextField.text { //3
                if let password = passwordTextField.text { //3
            
                    PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in  //3//23mins
                        
                        if error != nil { //3
                            var errorMessage = "Log In Failed - Try Again" //3
                            if let newError = error as? NSError { //3//15mins if error can be casted to an NSError which it shoul be able to
                                if let detailError = newError.userInfo["error"] as? String { //3
                                    errorMessage = detailError //3
                                } //3
                                self.errorLabel.isHidden = false //3
                                self.errorLabel.text = errorMessage //3
                            } else { //3
                                print("Login Successful") //3
                                self.performSegue(withIdentifier: "updateSegue", sender: nil) //4 //29mins if signup was successful, then let user update their info
                            } //3
                        } //3
                        
                    }) //3 //22mins since usernameTF and passwordTF are both optional, unwrap it first with if-let
                } //3
            } //3
        } //3
    } //3
    
//changeLoginSignupButton Tapped //3
    @IBAction func changeLoginSignupButtonTapped(_ sender: Any) { //3 //11mins
        if signUpMode{ //3
            loginSignupButton.setTitle("Log In", for: .normal) //3
            changeLoginSignupButton.setTitle("Sign Up", for: .normal) //3
            signUpMode = false //3
        } else { //3
            loginSignupButton.setTitle("Sign Up", for: .normal) //3
            changeLoginSignupButton.setTitle("Log In", for: .normal) //3
            signUpMode = true //3
        } //3
    } //3
    
    
//viewDidAppear //4 //30mins
    override func viewDidAppear(_ animated: Bool) { //4 //30mins check and see if current user is not equal to nil, if that is the case then we'll know they have logged in before and they're ready to use the app instead of the "updateSegue"
        if PFUser.current() != nil { //4 //30mins //if current user is not empty...
            self.performSegue(withIdentifier: "updateSegue", sender: nil) //4 //30mins
        } //4 //30mins
    } //4 //30mins
    
}
