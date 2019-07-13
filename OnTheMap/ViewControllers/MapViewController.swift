//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Devanshu on 19/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import UIKit
import MapKit
import CoreGraphics

class MapViewContoller: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var studentPins: MKMapView!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        studentPins.delegate = self
        
    }
    
    // Setting up the annotation locations via the studentlocationarray in which the latitude and longitude of the sutdents are contained
        
    override func viewWillAppear(_ animated:Bool) {
            
        super.viewWillAppear(animated)
        
        // Make annotations using Student locations data and add them to the MapView
        
        var locationannotations = [MKPointAnnotation]()
        
        for locationsofstudents in StudentData.sharedinstance.studentLocationArray {
            
            let latitude = CLLocationDegrees(locationsofstudents.latitude)
            
            let longitude = CLLocationDegrees(locationsofstudents.longitude)
            
            let studentLocationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let studentLocationAnnotation = MKPointAnnotation()
            
            studentLocationAnnotation.coordinate = studentLocationCoordinate
            
            studentLocationAnnotation.title = "\(locationsofstudents.firstName) \(locationsofstudents.lastName)"
            
            studentLocationAnnotation.subtitle = "\(locationsofstudents.mediaURL)"
            
            locationannotations.append(studentLocationAnnotation)
            
            debugPrint("Pins dropped")
            
    }
        
        studentPins.addAnnotations(locationannotations)
        
        var myCoordinates = CLLocationCoordinate2D(latitude:
            
            UdacityClient.MapConstants.defaultLatitude, longitude: UdacityClient.MapConstants.defaultLongitude)
        
        if let myLocation = StudentData.sharedinstance.myLocation {
            
            myCoordinates = CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude)
        }
        
        let region = MKCoordinateRegionMakeWithDistance(myCoordinates, UdacityClient.MapConstants.mapViewLargeScale, UdacityClient.MapConstants.mapViewLargeScale)
        
        studentPins.setRegion(region, animated: true)
        
    }
    
    // Setting a pin
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: UdacityClient.MapConstants.pinReusableIdentifier)
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: UdacityClient.MapConstants.pinReusableIdentifier)
            
            pinView!.canShowCallout = true
            
            pinView!.tintColor = .blue
            
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            
            pinView!.annotation = annotation
            
        }
        
        debugPrint("Pins dropped 2")

        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            debugPrint("Pins dropped 3")
            
            var selectedStudentLocation: StudentLocation? = nil
            
            for location in StudentData.sharedinstance.studentLocationArray {
                
                if (location.latitude == view.annotation?.coordinate.latitude) && (location.longitude == view.annotation?.coordinate.longitude) {
                    
                    selectedStudentLocation = location
                    
                }
            }
            
            guard let selectedLocation = selectedStudentLocation else {
                
                let selectedlocationalert = UIAlertController(title: "Alert!", message: "Location not found!", preferredStyle: .alert)
                
                selectedlocationalert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                present(selectedlocationalert, animated: true, completion: nil)
                
                return
            }
            
            if let mediaURL = URL(string: selectedLocation.mediaURL),
                UIApplication.shared.canOpenURL(mediaURL) {
                
                UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
                
            } else {
                
                let invalidURLAlert = UIAlertController(title: "Alert!", message: "Invalid URL!", preferredStyle: .alert)
                
                invalidURLAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                present(invalidURLAlert, animated: true, completion: nil)
                
            }
        }
    }
}
