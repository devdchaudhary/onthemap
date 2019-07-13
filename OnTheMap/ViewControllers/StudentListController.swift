//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Devanshu on 19/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation
import UIKit


class StudentListController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    // Showing the list of all students who have added annotations
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return StudentData.sharedinstance.studentLocationArray.count
        
    }
    
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
 
 {
    
    let studentCell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as UITableViewCell!
    
    studentCell?.textLabel?.text = "\(StudentData.sharedinstance.studentLocationArray[indexPath.row].firstName) \(StudentData.sharedinstance.studentLocationArray[indexPath.row].lastName)"
    
    studentCell?.detailTextLabel?.text = "\(StudentData.sharedinstance.studentLocationArray[indexPath.row].mapString)"
    
    return studentCell!
    
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let mediaURL = URL(string: StudentData.sharedinstance.studentLocationArray[indexPath.row].mediaURL), UIApplication.shared.canOpenURL(mediaURL) {
            UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
            
        } else {
            
            let invalidURLAlert = UIAlertController(title: "Alert!", message: "Invalid URL!", preferredStyle: .alert)
            
            invalidURLAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(invalidURLAlert, animated: true, completion: nil)
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    
    {
        
        let defaultcellheight: CGFloat = 50
        
        
        return defaultcellheight
        
        
    }
    
    
    class func sharedinstance() -> StudentListController {
        
        struct Singleton {
            
            static let sharedinstance = StudentListController()
            
        }
        
        return Singleton.sharedinstance
        
    }
    
}
