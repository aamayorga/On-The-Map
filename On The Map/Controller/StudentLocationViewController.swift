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

    @IBAction func postLocation(_ sender: UIButton) {
        
    }
    
}
