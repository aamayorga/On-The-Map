//
//  LoginViewController.swift
//  On The Map
//
//  Created by Ansuke on 1/25/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
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
        guard !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty else {
            return displayError("Enter an email and password")
        }
        
        UdacityClient.sharedInstance().authenticateWithViewController(self, username: emailTextField.text!, password: passwordTextField.text!, completionHandlerForAuth: { (success, errorString) in
            DispatchQueue.main.async(execute: {
                if (success) {
                    print("Logged in!")
                    self.completeLogin()
                } else {
                    self.displayError(errorString!)
                }
            })
        })
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
    }
    
    func completeLogin() {
        
        ParseClient.sharedInstance().getStudentLocations(100, skip: nil, order: nil) { (success, data, error) in
            guard error == nil else {
                print("Error getting student locations.")
                return
            }
            
            if (success) {
                
                let dictionary = data!.map({ (student: [String: AnyObject]) -> StudentLocation in
                    StudentLocation.init(dictionary: student)
                })
                print(dictionary)
                ParseClient.sharedInstance().StudentInformationArray = dictionary
                print("Succ")
            }
        }
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerTabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func prepareForKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

}
