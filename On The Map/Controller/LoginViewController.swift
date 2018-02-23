//
//  LoginViewController.swift
//  On The Map
//
//  Created by Ansuke on 1/25/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        loginButton.isEnabled = true
        signUpButton.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(prepareForKeyboardDismissal), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        signUpButton.isEnabled = false
        guard !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty else {
            return displayError("Enter an email and password")
        }
        
        UdacityClient.sharedInstance().authenticateWithViewController(self, username: emailTextField.text!, password: passwordTextField.text!, completionHandlerForAuth: { (success, errorString) in
            DispatchQueue.main.async(execute: {
                if (success) {
                    self.completeLogin()
                    
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                } else {
                    self.displayError(errorString!)
                }
            })
        })
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let svc = SFSafariViewController(url: URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!)
        self.present(svc, animated: true, completion: nil)
        
    }
    
    func completeLogin() {
        
        ParseClient.sharedInstance().getStudentLocations(100, skip: nil, order: "-updatedAt") { (success, data, error) in
            guard error == nil else {
                self.displayError("Error getting student locations.")
                return
            }
            
            if (success) {
                
                let dictionary = data!.map({ (student: [String: AnyObject]) -> StudentLocation in
                    StudentLocation.init(dictionary: student)
                })
                
                StudentDatasource.sharedInstance().StudentInformationArray = dictionary
            }
        }
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerTabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            self.loginButton.isEnabled = true
            self.signUpButton.isEnabled = true
        })
    }
    
    @objc func prepareForKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

}
