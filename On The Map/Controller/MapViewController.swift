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
            if let urlString = view.annotation?.subtitle {
                let svc = SFSafariViewController(url: URL(string: urlString!)!)
                self.present(svc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshBarButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func logoutBarButton(_ sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().sessionID = nil
        dismiss(animated: true, completion: nil)
    }
}
