//
//  NewPinController1.swift
//  OnTheMap
//
//  Created by Devanshu on 19/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SearchLocationController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newlocationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        newlocationTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotifications()
        
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Finding a location on the map
    
    @IBAction func findonMap(_ sender: Any) {
        
        self.view.bringSubview(toFront: activityIndicator)
        
        activityIndicator.startAnimating()
        
        if let mapString = newlocationTextField.text, mapString != "" {
            
            
            StudentData.sharedinstance.myLocation?.mapString = mapString
            
            StudentData.sharedinstance.myLocation?.uniqueKey = UdacityClient.Constants.UdacityID
            
            let geocode = CLGeocoder()
            
            geocode.geocodeAddressString(mapString, completionHandler: {(placemarks, error) in
                
                if let placemark = placemarks?[0] {
                    
                    StudentData.sharedinstance.myLocation?.latitude =
                    
                    placemark.location!.coordinate.latitude
                    
                    StudentData.sharedinstance.myLocation?.longitude =
                    
                    placemark.location!.coordinate.longitude
                    
                    self.activityIndicator.stopAnimating()
                    
                    let NewPinController2VC = self.storyboard!.instantiateViewController(withIdentifier: "NewPinController2VC") as! AddPinController
                    
                    self.navigationController?.pushViewController(NewPinController2VC, animated: true)
                    
                } else {
                    
                    self.activityIndicator.stopAnimating()
                    
                    let locationnotfoundAlert = UIAlertController(title: "Alert!", message: "Location not found!", preferredStyle: .alert)
                    
                    locationnotfoundAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                    self.present(locationnotfoundAlert, animated: true, completion: nil)
                    
                    
                }
                
                
                
            })
        
        } else {
            
            let emptylocationAlert = UIAlertController(title: "Alert!", message: "Location cannot be empty!", preferredStyle: .alert)
            
            emptylocationAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(emptylocationAlert, animated: true, completion: nil)
            
        }
        
}

    class func sharedInstance() -> SearchLocationController {
        
        struct Singleton {
            
            static let sharedInstance = SearchLocationController()
            
        }
        
        return Singleton.sharedInstance
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        newlocationTextField.resignFirstResponder()
        
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
    
    // Hide keyboard when turning device
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        newlocationTextField.resignFirstResponder()
        
    }
    
}
