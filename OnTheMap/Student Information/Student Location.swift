//
//  Student Location.swift
//  OnTheMap
//
//  Created by Devanshu on 16/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    // Students locations dictionary containing various info 
    
    var objectID: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    
    init?(_ locationDictionary: [String:AnyObject]) {

        if let firstName = locationDictionary[UdacityClient.ParseResponseKeys.firstName] as? String,
        let lastName = locationDictionary[UdacityClient.ParseResponseKeys.lastName] as? String,
        let latitude = locationDictionary[UdacityClient.ParseResponseKeys.latitude] as? Double,
        let longitude = locationDictionary[UdacityClient.ParseResponseKeys.longitude] as? Double,
        let mediaURL = locationDictionary[UdacityClient.ParseResponseKeys.mediaURL] as? String {
            
            self.firstName = firstName
            self.lastName = lastName
            self.latitude = latitude
            self.longitude = longitude
            self.mediaURL = mediaURL
            
        } else {
            
            return nil
            
        }
        
        if let objectID = locationDictionary[UdacityClient.ParseResponseKeys.objectID] as? String {
            
            self.objectID = objectID
            
        } else {
            
            self.objectID = ""
            
        }
        
        if let uniqueKey = locationDictionary[UdacityClient.ParseResponseKeys.uniqueKey] as? String {
            
            self.uniqueKey = uniqueKey
            
        } else {
            
            self.uniqueKey = ""
            
        }
        
        if let mapString = locationDictionary[UdacityClient.ParseResponseKeys.mapString] as? String {
            
            self.mapString = mapString
            
        } else {
            
            self.mapString = ""
            
        }
        
    }
    
}
