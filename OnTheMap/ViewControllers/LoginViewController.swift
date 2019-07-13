//
//  ViewController.swift
//  OnTheMap
//
//  Created by Devanshu on 15/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import UIKit
import MapKit

class LoginViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
        
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let userlocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        userlocationManager.delegate = self
        userlocationManager.desiredAccuracy = kCLLocationAccuracyBest
        userlocationManager.requestAlwaysAuthorization()
        
        CLLocationManager.locationServicesEnabled()
        userlocationManager.startUpdatingLocation()
        
        userNameField.delegate = self
        passwordField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        userNameField.text = nil
        
        passwordField.text = nil
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        userlocationManager.stopUpdatingLocation()
        
        unsubscribeToKeyboardNotifications()
        
    }
    
    // Button Actions
    
    @IBAction func signupButton(_ sender: Any) {
            
        performSegue(withIdentifier: "SignupViewSegue", sender: self)
        
        debugPrint("Signup Button Pressed")
        
    } 
    
    @IBAction func loginButton(_ sender: Any) {
        
        debugPrint("Login Button Pressed")
        
        self.view.bringSubview(toFront: activityIndicator)
        
        activityIndicator.startAnimating()
        
    UdacityClient.sharedinstance().retievesession(loginVC: self, completionHanderforlogin: {(success, error) in
        
        if success {
            
            debugPrint("Session retrieved")
            
        UdacityClient.sharedinstance().getUserInfo(completionHandlerforUserInfo: {(success, error) in
            
            if success {
                
                debugPrint("User info retrieved")
                
        UdacityClient.sharedinstance().getStudentlocation(completionHandlerForStudentLocations: {(success, error) in
            
            if success  {
                
                debugPrint("Student Locations retrieved")
                
                    performUIUpdatesOnMain {
                        
                        self.activityIndicator.stopAnimating()
                        self.login()
                        
        }
                
            } else {
                
                debugPrint("ERROR 1")
                
                            performUIUpdatesOnMain {
                                
                            self.activityIndicator.stopAnimating()
                                
                                let dismissAlert = UIAlertController(title: "Error!", message: error?.description, preferredStyle: .alert)
                                
                                dismissAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                
                                self.present(dismissAlert, animated: true, completion: nil)
                                
                            }
                        }
                    })
                
            } else {
               
                debugPrint("ERROR 2")
            
            performUIUpdatesOnMain {
                
            self.activityIndicator.stopAnimating()
                
                let dismissAlert = UIAlertController(title: "Error!", message: error?.description, preferredStyle: .alert)
                
                dismissAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(dismissAlert, animated: true, completion: nil)

    
        }
    }
})
    
    } else {
            
        debugPrint("ERROR 3")
            
        performUIUpdatesOnMain {
            
            self.activityIndicator.stopAnimating()
            
            let dismissAlert = UIAlertController(title: "Error!", message: error?.description, preferredStyle: .alert)
            
            dismissAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(dismissAlert, animated: true, completion: nil)
            
        }
        
      }
        
    })
            
  }  // Present the navigation controller
    
   private func login() {
            
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
    
        self.present(navigationController, animated: true, completion: nil)
    
    debugPrint("Navigation controller instantiated")
    
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userlocation: CLLocation = locations[0]
        
        StudentData.sharedinstance.myLocation?.latitude = userlocation.coordinate.latitude
        StudentData.sharedinstance.myLocation?.longitude = userlocation.coordinate.longitude
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        userNameField.resignFirstResponder()
        
        passwordField.resignFirstResponder()
        
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
        
        if passwordField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
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
