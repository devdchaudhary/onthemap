//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Devanshu on 19/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation
import UIKit


class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
    }
    
    // Adding a new annotation
    
    @IBAction func addnewPin(_ sender: UIBarButtonItem) {
  
        if StudentData.sharedinstance.locationExists {
            
            let existinglocationAlert = UIAlertController(title: "Alert!", message: "Location already exists. Do you want to overwrite?", preferredStyle: .alert)
            
            existinglocationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            existinglocationAlert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: { control in
                
                let newpinController = self.storyboard!.instantiateViewController(withIdentifier: "InputNavigationController") as! UINavigationController
                
                self.present(newpinController, animated: true, completion: nil)
                
            }))
            
            self.present(existinglocationAlert, animated: false, completion: nil)
            
        } else {
            
            let newpinController = self.storyboard!.instantiateViewController(withIdentifier: "InputNavigationController") as! UINavigationController
            
            self.present(newpinController, animated: true, completion: nil)
        
        }
    
    }
    
    // Updating the database
    
    @IBAction func refreshlocation(_ sender: UIBarButtonItem) {
        
    UdacityClient.sharedinstance().getStudentlocation(completionHandlerForStudentLocations: {(success, error) in
            
            if success {
                
                performUIUpdatesOnMain {
                    
                    let databaseupdateAlert = UIAlertController(title: "Alert!", message: "Database Updated", preferredStyle: .alert)
                    
                    databaseupdateAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(databaseupdateAlert, animated: true, completion: nil)
                    
                    StudentListController.sharedinstance().tableView.reloadData()
                    
                }
                
            }  else {
                
                performUIUpdatesOnMain {
                    
                    let refresherrorAlert = UIAlertController(title: "Alert!", message: error?.description, preferredStyle: .alert)
                    
                    refresherrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                    self.present(refresherrorAlert, animated: true, completion: nil)
                    
                }
                
            }
            
        })
        
    }
    
    // Logging out
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
    UdacityClient.sharedinstance().deleteSession(completionHandlerForDeleteSession: {(success, error) in
            
            if success {
                
                performUIUpdatesOnMain {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    debugPrint("Logged out")
                    
                }
            
        } else {
                
                performUIUpdatesOnMain {
                    
                    let deletererrorAlert = UIAlertController(title: "Alert!", message: error?.description, preferredStyle: .alert)
                    
                    deletererrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                    self.present(deletererrorAlert, animated: true, completion: nil)
                    
                }
            }
        })
    }
}

