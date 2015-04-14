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

class InformationPostingViewController: UIViewController {
   
    @IBOutlet weak var removeLocation: UIBarButtonItem!
    @IBOutlet weak var locationSearchString: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var studentURL: UITextField!
    
    var myAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // Show the enter location view
        view.viewWithTag(1)!.hidden = false
        // Hide the map & URL view
        view.viewWithTag(2)!.hidden = true
        removeLocation.enabled = false
        if udacityUser.hasStudentLocation! {
            removeLocation.enabled = true
        }
    }
    
    @IBAction func findLocation(sender: UIButton) {
        // try to reverse geolocate to position in
        // If succes: show the mapview: else show (error)message
        var geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationSearchString.text, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                let newPlace = MKPlacemark(placemark: placemark)
                
                self.myAnnotation.coordinate = (CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude))
                self.myAnnotation.title = newPlace.title
                self.myAnnotation.subtitle = "Is this the place?"
                self.mapView.addAnnotation(self.myAnnotation)
                //self.mapView.addAnnotation(MKPlacemark(placemark: newPlace))
                
                //var span = MKCoordinateSpanMake(0.01, 0.01)
                // This sets the 'scale or zoom' of the map
                var span = MKCoordinateSpanMake(0.1, 0.1)
                //create MKCoordinateRegion structure
                // get the long and lat of the placemark and turn it into a center for the region
                var center = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude)
                var region = MKCoordinateRegionMake(center, span)
                //set the region of the placemark and the map will show it
                self.mapView.setRegion(region, animated: true)
                

                self.view.viewWithTag(1)!.hidden = true
                self.view.viewWithTag(2)!.hidden = false
                
            } else {
                // TODO: show error message to user.
                println("Location could not be found")
            }
        })

    }
    
    /*  TO DO:
    
    1) Add location search based on search string (with FIND button) + alerts (if not found) and confirmation (if found)
    2) Add URL (mandatory)
    3) Switch between mapview and URL view
    4) Add submit button + POST
    5) Make sure the once posted there are only updates (PUT) to prevent multiple locations from the same students

    

    */
    
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
            ParseClient.sharedInstance().pushStudenLocation(newLocation) {succes, error in
                if succes {
                    // REMOVE THIS LINE
                    //println("post/put succesfull")
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    if let err = error {
                        println(err)
                    }
                }
            }
            
        } else {
            var invalidURLAlert = UIAlertController(title: "Alert", message: "The url you entered is not valid \n (start with http:// or https://)", preferredStyle: UIAlertControllerStyle.Alert)
            invalidURLAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in  //do nothing
                }))
            presentViewController(invalidURLAlert, animated: true, completion: nil)
        }

    }
    
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
            ParseClient.sharedInstance().deleteStudentLocation() {succes, error in
                if succes {
                    //REMOVE THIS LINE
                    println("Delete succesfull")
                } else {
                    //REMOVE THIS LINE
                    println("delete failed")
                }
            self.dismissViewControllerAnimated(true, completion: nil)
            }
            }))
            
        presentViewController(removeAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelLocation(sender: UIBarButtonItem) {
        // cancel the update/creation StudentLocation
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
