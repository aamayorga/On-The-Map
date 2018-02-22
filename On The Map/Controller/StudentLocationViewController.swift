//
//  StudentLocationViewController.swift
//  On The Map
//
//  Created by Ansuke on 2/15/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingStackView: UIStackView!
    @IBOutlet weak var finishButton: UIButton!
    
    var mapString: String?
    var mediaURL: String?
    var placemark: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = (placemark?.location?.coordinate)!
        annotation.title = "\(placemark?.locality ?? ""), \(placemark?.administrativeArea ?? "")"
            
        mapView.addAnnotation(annotation)
        mapView.setCenter((placemark?.location?.coordinate)!, animated: true)
        let coordsRegion = MKCoordinateRegionMake((placemark?.location?.coordinate)!, MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        mapView.setRegion(coordsRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.pinTintColor = .red
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func hideLoadingViewAndDisableButton(_ disable: Bool) {
        loadingStackView.isHidden = disable
        finishButton.isEnabled = disable
    }

    @IBAction func postLocation(_ sender: UIButton) {
        
        hideLoadingViewAndDisableButton(false)
        
        let userId = UdacityClient.sharedInstance().userID
        var firstName = String()
        var lastName = String()
        
        UdacityClient.sharedInstance().getPublicUserData(userId!) { (success, results, error) in
            guard success else {
                self.displayError("Getting user data was unsuccessful")
                return
            }
            
            guard error == nil else {
                self.displayError("Error in retreving user data")
                return
            }
            
            guard let userDictionary = results else {
                self.displayError("No user dictionary returned")
                return
            }
            
            firstName = userDictionary[ParseClient.JSONResponseKeys.FirstName] as? String ?? ""
            lastName = userDictionary[ParseClient.JSONResponseKeys.LastName] as? String ?? ""
            
            guard let latitude = self.placemark?.location?.coordinate.latitude, let longitude = self.placemark?.location?.coordinate.longitude else {
                self.displayError("Invalid map coordinates")
                return
            }
            
            ParseClient.sharedInstance().postStudentLocation(userID: userId, firstName: firstName, lastName: lastName, mapString: self.mapString, mediaURL: self.mediaURL, latitude: latitude, longitude: longitude, completionHandlerForPostingStudentLoaction: { (success, error) in
                
                guard error == nil else {
                    self.displayError("Error with posting location, please try again")
                    return
                }
                
                if success {
                    self.dismiss(animated: true, completion: nil)
                    print("\n\nTHATS IT! IT IS OVER!")
                } else {
                    self.displayError("Error with posting location, please try again")
                    return
                }
            })
        }
        
        
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            self.hideLoadingViewAndDisableButton(true)
        })
    }
}
