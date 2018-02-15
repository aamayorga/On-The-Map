//
//  MapViewController.swift
//  On The Map
//
//  Created by Ansuke on 2/1/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addStudentAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let urlString = view.annotation?.subtitle else {
                print("No URL String")
                return
            }
            
            guard let validURL = URL(string: urlString!) else {
                print("Invalid URL")
                return
            }
            
            if UIApplication.shared.canOpenURL(validURL) {
                let svc = SFSafariViewController(url: validURL)
                self.present(svc, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func addStudentAnnotations() {
        var annotations = [MKPointAnnotation]()
        
        for student in ParseClient.sharedInstance().StudentInformationArray {
            
            guard let lat = student.latitude else {
                print("Latitude is nil")
                continue
            }
            
            guard let long = student.longitude else {
                print("Longitude is nil")
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "") \(last ?? "")"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    @IBAction func logoutBarButton(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        UdacityClient.sharedInstance().logOutOfSession { (results, error) in
            guard error == nil else {
                print("Error logging out")
                sender.isEnabled = true
                return
            }
            
            print(results!)
            UdacityClient.sharedInstance().sessionID = nil
            ParseClient.sharedInstance().StudentInformationArray = []
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshBarButton(_ sender: UIBarButtonItem) {
        ParseClient.sharedInstance().getStudentLocations(100, skip: nil, order: nil) { (success, data, error) in
            guard error == nil else {
                print("Error getting student locations.")
                return
            }
            
            if (success) {
                let dictionary = data!.map({ (student: [String: AnyObject]) -> StudentLocation in
                    StudentLocation.init(dictionary: student)
                })
                
                ParseClient.sharedInstance().StudentInformationArray = dictionary
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                DispatchQueue.main.async(execute: {
                    self.addStudentAnnotations()
                })
            }
        }
    }
}
