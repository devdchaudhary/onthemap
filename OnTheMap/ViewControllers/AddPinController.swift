//
//  NewPinController2.swift
//  OnTheMap
//
//  Created by Devanshu on 19/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddPinController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var urlLabel: UITextField!
    @IBOutlet weak var placedpinMapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotifications()
        
    }
    
    override func viewDidLoad() {
        
        // Placing a new pin on the map
        
        super.viewDidLoad()
        
        urlLabel.delegate = self
        
        let placedLatitude = CLLocationDegrees(StudentData.sharedinstance.myLocation!.latitude)
        
        let placedLongitude = CLLocationDegrees(StudentData.sharedinstance.myLocation!.longitude)
        
        let placedCoordinate = CLLocationCoordinate2D(latitude: placedLatitude, longitude: placedLongitude)
        
        let locationAnnotation = MKPointAnnotation()
        
        locationAnnotation.coordinate = placedCoordinate
        
        locationAnnotation.title = "\(StudentData.sharedinstance.myLocation!.firstName) \(StudentData.sharedinstance.myLocation!.lastName)"
        locationAnnotation.subtitle = "\(StudentData.sharedinstance.myLocation!.mediaURL)"
        
        placedpinMapView.addAnnotation(locationAnnotation)
        
        let region = MKCoordinateRegionMakeWithDistance(placedCoordinate, UdacityClient.MapConstants.mapViewFineScale, UdacityClient.MapConstants.mapViewFineScale)
        
        placedpinMapView.setRegion(region, animated: true)
        
    }
    
    
    @IBAction func Submit(_ sender: UIButton) {
        
        guard let locationURL = urlLabel.text, locationURL != "" else {
            
            let emptylocationAlert = UIAlertController(title: "Alert!", message: "Location cannot be empty!", preferredStyle: .alert)
            
            emptylocationAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(emptylocationAlert, animated: true, completion: nil)
        
            return
            
        }
        
       
        let latitudeString = String(describing: StudentData.sharedinstance.myLocation!.latitude)
        let longitudeString = String(describing: StudentData.sharedinstance.myLocation!.longitude)
        
    
        if StudentData.sharedinstance.locationExists {
            
            UdacityClient.sharedinstance().pinNewLocation(locationIDToReplace: StudentData.sharedinstance.myLocation!.objectID, mapString: (StudentData.sharedinstance.myLocation?.mapString)!, mediaURL: locationURL, latitude: latitudeString, longitude: longitudeString, completionHandlerforNewLocation: {(success, error)
                
                in
                
                if success {
                    
                    debugPrint("Location Submitted")
                    
                    performUIUpdatesOnMain {
                        
                    self.navigationController?.dismiss(animated: true, completion: nil)
                       
                        
                    }
                
                } else {
                    
                    performUIUpdatesOnMain {
                        
                    let putlocationfailedAlert = UIAlertController(title: "Alert!", message: "Failed to put location!", preferredStyle: .alert)
                    
                    putlocationfailedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        
                    self.present(putlocationfailedAlert, animated: true, completion: nil)
                    
                }
                    
            }
                
        })
        
        } else {
            
            UdacityClient.sharedinstance().postNewLocation(mapString: (StudentData.sharedinstance.myLocation?.mapString)!, mediaURL: locationURL, latitude: latitudeString, longitude: longitudeString, completionHandlerForPostNewLocation: {(success, error)
                
                in
                
                if success {
                    
                    StudentData.sharedinstance.locationExists = true
                    
                    performUIUpdatesOnMain {
                        
                        self.navigationController?.dismiss(animated: true, completion: nil)
                        
                    }
                    
                } else {
                    
                    performUIUpdatesOnMain {
                        
                        let postlocationfailedAlert = UIAlertController(title: "Alert!", message: "Failed to post location!", preferredStyle: .alert)
                        
                        postlocationfailedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        
                        self.present(postlocationfailedAlert, animated: true, completion: nil)
                        
            }
                    
        }
                
     })
            
   }
        
}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        urlLabel.resignFirstResponder()
        
        return true
        
    }
    
    // Keyboard methods
    
    // Function for sending the notification for enabling the keyboard
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // Function for moving the frame up is keyboard is called
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        view.frame.origin.y = 0
        
    }
    
    // Function for determining the keyboard height and sending that as a notification to KeyboardWillShow function
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardsize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardsize.cgRectValue.height
        
    }
    
    // Function for sending the notification for disabling the keyboard
    
    func unsubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    // Function for hiding the keyboard once it's done getting used
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        view.frame.origin.y = 0
        
    }
    
}
