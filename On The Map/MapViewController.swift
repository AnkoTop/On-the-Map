//
//  MapViewController.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var studentLocations: [StudentLocation] = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateMapView()
        
        // Listen for updates of the StudenLocation data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMapView", name: StudentLocationNotificationKey , object: nil)
    }
    
    func updateMapView() {
        
        dispatch_async(dispatch_get_main_queue()) {
 
            // remove old annotations
            if self.mapView.annotations.count > 0 {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.annotations.removeAll(keepCapacity: true)
            }
        
            // get the necessary data from the dictionary
            self.studentLocations = globalStudentLocations
            for student in self.studentLocations {
            
                let lat = CLLocationDegrees(student.lattitude!)
                let long = CLLocationDegrees(student.longitude!)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
                let first = student.firstName
                let last = student.lastName
                let mediaURL = student.mediaURL
            
                // create the annotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
            
                self.annotations.append(annotation)
            }
        
            // add the annotations to the map.
            self.mapView.addAnnotations(self.annotations)
            // show them on a overviewlevel instead of zoomed in
            self.mapView.showAnnotations(self.annotations, animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if annotationView.annotation!.subtitle != nil {
            if control == annotationView.rightCalloutAccessoryView {
                let app = UIApplication.sharedApplication()
                app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
            }
        }
    }

}
