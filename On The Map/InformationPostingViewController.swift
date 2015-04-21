//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Anko Top on 10/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var removeLocation: UIBarButtonItem!
    @IBOutlet weak var locationSearchString: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var studentURL: UITextField!
    @IBOutlet weak var cancelLocation: UIBarButtonItem!
    
    @IBOutlet weak var geoActivity: UIActivityIndicatorView!
    
    var myAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Textfield delegates
        self.locationSearchString.delegate = self
        self.studentURL.delegate = self
    }
  
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // Show the enter location view
        view.viewWithTag(1)!.hidden = false
        // Hide the map & URL view
        view.viewWithTag(2)!.hidden = true
        self.removeLocation.enabled = false
        
        if udacityUser.hasStudentLocation! {
            self.removeLocation.enabled = true
            self.showAlertWithOkAndNoAction("", message: "You have an active Student Location.\n You can move it to the trash or proceed to update.")
        }
    }
    
    
    @IBAction func findLocation(sender: UIButton) {
        
        self.geoActivity.startAnimating()
        if locationSearchString.text == "" {
            self.showAlertWithOkAndNoAction("Find location", message: "You must enter a valid location")
        } else {
            
            // try to reverse geolocate the searchstring to a position
            var geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(locationSearchString.text, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                
                    let newPlace = MKPlacemark(placemark: placemark)
                
                    self.myAnnotation.coordinate = (CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude))
                    self.myAnnotation.title = newPlace.title
                    self.myAnnotation.subtitle = "Is this the place you where searching for?"
                    self.mapView.addAnnotation(self.myAnnotation)
                    
                    // Set the 'scale/zoom' of the map
                    var span = MKCoordinateSpanMake(0.05, 0.05)
                    //create MKCoordinateRegion structure
                    var center = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude)
                    var region = MKCoordinateRegionMake(center, span)
                    //set the region of the placemark and the map will show it
                    self.mapView.setRegion(region, animated: true)
 
                    self.view.viewWithTag(1)!.hidden = true
                    self.view.viewWithTag(2)!.hidden = false
                    self.cancelLocation.title = "Back"
                    self.removeLocation.enabled = false
                
                } else {
                    self.showAlertWithOkAndNoAction("Invalid Location", message: "The location you entered is not valid or could not be found")
                }
            })
        }
        self.geoActivity.stopAnimating()
    }
    
    
    @IBAction func submitStudenLocation(sender: UIButton) {
        // check if URL is correct: if not show an alert
        if isValidaUrl(studentURL.text) {
            // set the location data
            var newLocation = StudentLocation()
            newLocation.mediaURL = studentURL.text
            newLocation.mapString = locationSearchString.text
            newLocation.lattitude = Float(self.myAnnotation.coordinate.latitude as Double)
            newLocation.longitude = Float(self.myAnnotation.coordinate.longitude as Double)
           
            //post/put the location
            ParseClient.sharedInstance().pushStudenLocation(newLocation) {succes, message, error in
                if succes {
                   self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    if !succes {
                        self.showAlertWithOkAndNoAction("Student Location", message: message)
                    }
                }
            }
        } else {
            self.showAlertWithOkAndNoAction("Alert", message: "The url you entered is not valid \n (start with http:// or https://)")
        }
    }
    
    
    // URL validity checker
    func isValidaUrl (stringURL : NSString) -> Bool {
        
        var urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        var urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(stringURL)
    }

    
    @IBAction func deleteCurrentLocation(sender: UIBarButtonItem) {
        //remove existing location (show alert)
        var removeAlert = UIAlertController(title: "Alert", message: "You are about to remove your existing student location,", preferredStyle: UIAlertControllerStyle.Alert)
        
        removeAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
            //delete the location
            ParseClient.sharedInstance().deleteStudentLocation() {succes, message, error in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }))
            
        presentViewController(removeAlert, animated: true, completion: nil)
    }
    
    // cancel entering the update/creation StudentLocation
    @IBAction func cancelLocation(sender: UIBarButtonItem) {
        //depending on what we see either show previous view (find location) or cancel th addition of a location
        if self.view.viewWithTag(1)!.hidden {
            // enter another location
            view.viewWithTag(1)!.hidden = false
            view.viewWithTag(2)!.hidden = true
            self.cancelLocation.title = "Cancel"
            if udacityUser.hasStudentLocation! {
                self.removeLocation.enabled = true
            }
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    // Helper: show alert
    func showAlertWithOkAndNoAction(title: String, message: String) {
        var generalAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        generalAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in  //do nothing
        }))
        presentViewController(generalAlert, animated: true, completion: nil)
    }
    
    
    //textfield delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }    
}
