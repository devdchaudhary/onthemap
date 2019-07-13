//
//  SignupViewController.swift
//  OnTheMap
//
//  Created by Devanshu on 19/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import UIKit
import WebKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var signupView: WKWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Signup URL
        
    let signupURL = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")
    
    let request = URLRequest(url: signupURL!)
    
    signupView.load(request)
        
    }
    
}
