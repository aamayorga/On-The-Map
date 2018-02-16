//
//  InformationViewController.swift
//  On The Map
//
//  Created by Ansuke on 2/14/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import MapKit

class InformationViewController: UIViewController {

    @IBOutlet weak var cityStateTextField: UITextField!
    @IBOutlet weak var sharedURLTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Cancel button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissCurrentView))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    @IBAction func findLocationButton(_ sender: UIButton) {
        //disableEnableTappableObjects()
        if (cityStateTextField.text?.isEmpty)! {
            displayError("Please enter a city and state location")
            return
        }
        
        let locationString = cityStateTextField.text!
        CLGeocoder().geocodeAddressString(locationString) { (placemark, error) in
            guard error == nil else {
                let locationError = error as! CLError
                switch locationError.errorCode {
                case 0:
                    self.displayError("Location is unknown.\nAre you sure its valid?")
                case 2:
                    self.displayError("Unable to access network. Try again.")
                default:
                    self.displayError("Failed to get location.")
                }
                return
            }
            
            guard let place = placemark?[0] else {
                self.displayError("Failed to get location.")
                return
            }
            
            let studentLocationView = self.storyboard?.instantiateViewController(withIdentifier: "StudentLocationViewController") as! StudentLocationViewController
            studentLocationView.placemark = place
            self.navigationController?.show(studentLocationView, sender: self)
        }
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            //self.disableEnableTappableObjects()
        })
    }
    
    @objc func dismissCurrentView() {
        dismiss(animated: true, completion: nil)
    }
    
    func disableEnableTappableObjects() {
        findLocationButton.isEnabled = !findLocationButton.isEnabled
        sharedURLTextField.isEnabled = !sharedURLTextField.isEnabled
        findLocationButton.isEnabled = !findLocationButton.isEnabled
    }
}
