//
//  ParseFunctions.swift
//  OnTheMap
//
//  Created by Devanshu on 16/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation

// Getting data from the serialized JSON

extension UdacityClient {
    
    // Retrieve Session and User ID
    
    func retievesession(loginVC: LoginViewController, completionHanderforlogin: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        guard let userName = loginVC.userNameField.text, let password = loginVC.passwordField.text, userName != "", password != "" else {
            
            completionHanderforlogin(false, NSError(domain: "retievesession", code: 1, userInfo: [NSLocalizedDescriptionKey:"Login and/or Password is empty"]))
            
            return
            
        }
        
    let loginurl = UdacityClient.sharedinstance().createURL(apiHost: UdacityClient.Constants.UdacityApiHost, apiPath: UdacityClient.Constants.UdacityApiPath, withExtension: "/session", parameters: nil)
        
    let _ = UdacityClient.sharedinstance().retrieveUdacityData(UdacityClient.Methods.post, withURL: loginurl, httpHeaderFieldValue: [UdacityClient.JSONHeaders.accept:UdacityClient.JSONValues.appJSON,UdacityClient.JSONHeaders.contentType:UdacityClient.JSONValues.appJSON], httpBody: "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}", completionHandlerForTask: {(data, error) in
            
            
            guard error == nil else {
                
                if (error?.description.contains("offline"))! {
                    
                    completionHanderforlogin(false, NSError(domain: "retievesession", code: 1, userInfo: [NSLocalizedDescriptionKey:"Internet connection is offline"]))
                    
                } else {
                    
                    completionHanderforlogin(false, error)
                    
                }
                
                return
                
            }
            
            let postSession = data as! [String:AnyObject]
            
            let sessionInfo = postSession[UdacityClient.UdacityResponseKeys.session] as! [String:AnyObject]
            
            if let sessionID = sessionInfo[UdacityClient.UdacityResponseKeys.id] as? String {
                
                UdacityClient.sharedinstance().sessionID = sessionID
                
            } else {
                
                completionHanderforlogin(false, NSError(domain: "retievesession", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot retrieve info: \(UdacityClient.UdacityResponseKeys.id)"]))
                
            }
            
            let accountInfo = postSession[UdacityClient.UdacityResponseKeys.account] as! [String:AnyObject]
            
            if let userID = accountInfo[UdacityClient.UdacityResponseKeys.key] as? String {
                
                UdacityClient.sharedinstance().userID = userID
        
            } else {
                
                completionHanderforlogin(false, NSError(domain: "retievesession", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot retrieve info: \(UdacityClient.UdacityResponseKeys.id)"]))
                
                
            }
        
            completionHanderforlogin(true, nil)
            
        })

    }
    
    // Retrieve student information
    
    func getUserInfo(completionHandlerforUserInfo: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let userinfoURL = UdacityClient.sharedinstance().createURL(apiHost: UdacityClient.Constants.UdacityApiHost, apiPath: UdacityClient.Constants.UdacityApiPath, withExtension: "/users/\(UdacityClient.sharedinstance().userID!)", parameters: nil)
        
        debugPrint("Students information retrieved")
        
        let _ = UdacityClient.sharedinstance().retrieveUdacityData(UdacityClient.Methods.get, withURL: userinfoURL, httpHeaderFieldValue: [:], httpBody: nil, completionHandlerForTask: {(data, error) in
                    
                    guard error == nil else {
                        
                        if(error?.description.contains("offline"))! {
                            
                            completionHandlerforUserInfo(false, NSError(domain: "getUserInfo", code: 1, userInfo: [NSLocalizedDescriptionKey:"Internet connection is offline"]))
                            
                        } else {
                            
                            completionHandlerforUserInfo(false, error)
                            
                        }
                        
                        return
                    
                    }
                    
        
        let getUserData = data as! [String:AnyObject]

        let userInfo = getUserData[UdacityClient.UserData.user] as! [String:AnyObject]
        
        if let userFirstName = userInfo[UdacityClient.UserData.firstName] as? String, let userLastName = userInfo[UdacityClient.UserData.lastName] as? String {
            
            
            let locationParameters = [UdacityClient.ParseResponseKeys.firstName:userFirstName,
                                      UdacityClient.ParseResponseKeys.lastName:userLastName,
                                      UdacityClient.ParseResponseKeys.latitude:UdacityClient.MapConstants.defaultLatitude,
                                      UdacityClient.ParseResponseKeys.longitude:UdacityClient.MapConstants.defaultLongitude,
                                      UdacityClient.ParseResponseKeys.mediaURL:UdacityClient.MapConstants.defaultMediaURL] as [String:AnyObject]
            
            
            StudentData.sharedinstance.myLocation = StudentLocation(locationParameters)
            
            completionHandlerforUserInfo(true, nil)
            
        } else {
            
            completionHandlerforUserInfo(false, NSError(domain: "getUserInfo", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot retrieve user info: \(UdacityClient.UserData.firstName), \(UdacityClient.UserData.lastName))"]))
        
            }
                    
        })
        
    }

    // Get student locations

    func getStudentlocation(completionHandlerForStudentLocations: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
       let studentlocationURL = UdacityClient.sharedinstance().createURL(apiHost: UdacityClient.Constants.ParseApiHost, apiPath: UdacityClient.Constants.ParseApiPath, withExtension: nil, parameters: [UdacityClient.Constants.ParseAPILimit:String(UdacityClient.Constants.LimitLocations), UdacityClient.Constants.ParseAPIOrder: "-\(UdacityClient.ParseResponseKeys.updatedAt)"])
        
        let _ = UdacityClient.sharedinstance().retrieveUdacityData(UdacityClient.Methods.get, withURL: studentlocationURL, httpHeaderFieldValue: UdacityClient.CommonJSONHeaders.jsonHeaderCommonParse, httpBody: nil, completionHandlerForTask: { (data, error)
            
            in
            
            guard error == nil else {
                
                if(error?.description.contains("offline"))! {
                    
                    completionHandlerForStudentLocations(false, NSError(domain: "getStudentlocation", code: 1, userInfo: [NSLocalizedDescriptionKey:"Internet connection is offline"]))
                    
                } else {
                    
                    completionHandlerForStudentLocations(false, error)
                    
                }
                
                return
                
            }
            
            let locationData = data as! [String:AnyObject]
            
            guard let locationarray = locationData[UdacityClient.ParseResponseKeys.results] as? [[String:AnyObject]] else {
                
                completionHandlerForStudentLocations(false, NSError(domain: "getStudentlocation", code: 1, userInfo:[NSLocalizedDescriptionKey:"Location data not parsed"]))
                
                return
                
            }


     StudentData.sharedinstance.studentLocationArray = []

            for location in locationarray {
                
                if let studentLocation = StudentLocation(location) {
                    
                    StudentData.sharedinstance.studentLocationArray.append(studentLocation)
                    
                }
            
            }


        completionHandlerForStudentLocations(true, nil)
            
            
        })
        
   }


  // Deleting a session

    func deleteSession(completionHandlerForDeleteSession: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let deleteSessionURL = UdacityClient.sharedinstance().createURL(apiHost: UdacityClient.Constants.UdacityApiHost, apiPath: UdacityClient.Constants.UdacityApiPath, withExtension: "/session", parameters: [:])
        
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookiesStorage = HTTPCookieStorage.shared
        for cookie in sharedCookiesStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                
                xsrfCookie = cookie
                
            }
            
        }
        
        var headerParameters = [String:String]()
        
        if let xsrfCookie  = xsrfCookie {
            
            headerParameters[UdacityClient.JSONHeaders.xsrfToken] = xsrfCookie.value
            
        }
        
        
        let _ = UdacityClient.sharedinstance().retrieveUdacityData(UdacityClient.Methods.delete, withURL: deleteSessionURL, httpHeaderFieldValue: headerParameters, httpBody: nil, completionHandlerForTask: {(data, error) in
            
            guard error == nil else {
                
                if (error?.description.contains("offline"))! {
                    
                    completionHandlerForDeleteSession(false, NSError(domain: "deleteSession", code: 1, userInfo: [NSLocalizedDescriptionKey:"Internet connection is offline"]))
                    
                } else {
                    
                    completionHandlerForDeleteSession(false, error)
                    
                }
                
                return
                
            }
            
            let postSession = data as! [String:AnyObject]
            
            let sessionInfo = postSession[UdacityClient.UdacityResponseKeys.session] as! [String:AnyObject]
            
            if let sessionID = sessionInfo[UdacityClient.UdacityResponseKeys.id] as? String {
                
                completionHandlerForDeleteSession(true, nil)
                print("DELETED", sessionID)
                
            } else {
                
                completionHandlerForDeleteSession(false, NSError(domain: "deleteSession", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot delete session ID"]))
                
            }
        
        })
}
    
    
//Posting new locaiton
    
    func postNewLocation(mapString: String, mediaURL: String, latitude: String, longitude: String, completionHandlerForPostNewLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let urlForPostNewLocation = UdacityClient.sharedinstance().createURL(apiHost: UdacityClient.Constants.ParseApiHost, apiPath: UdacityClient.Constants.ParseApiPath, withExtension: nil, parameters: nil)
        
        var headerParameters = UdacityClient.CommonJSONHeaders.jsonHeaderCommonParse
        
        headerParameters[UdacityClient.JSONHeaders.contentType] = UdacityClient.JSONValues.appJSON
        
        let jsonBody = "{\"uniqueKey\": \"\(UdacityClient.Constants.UdacityID)\", \"firstName\": \"\(StudentData.sharedinstance.myLocation!.firstName)\", \"lastName\": \"\(StudentData.sharedinstance.myLocation!.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        let _ = UdacityClient.sharedinstance().retrieveUdacityData(UdacityClient.Methods.post, withURL: urlForPostNewLocation, httpHeaderFieldValue: headerParameters, httpBody: jsonBody, completionHandlerForTask: {(data, error) in
            
            guard error == nil else {
                
                if (error?.description.contains("offline"))! {
                    
                    completionHandlerForPostNewLocation(false, NSError(domain: "postNewLocation", code: 1, userInfo: [NSLocalizedDescriptionKey:"Internet connection is offline"]))
                    
                } else {
                    
                    completionHandlerForPostNewLocation(false, error)
                    
                }
                
                return
                
            }
            
            let sessionInfo = data as! [String:AnyObject]
            
            if let objectID = sessionInfo[UdacityClient.ParseResponseKeys.objectID] {
                StudentData.sharedinstance.myLocation?.objectID = (objectID as! String)
                completionHandlerForPostNewLocation(true, nil)
                
            } else {
                
                completionHandlerForPostNewLocation(false, NSError(domain: "postNewLocation", code: 1, userInfo: [NSLocalizedDescriptionKey:"Internet connection is offline"]))
            }
        })
    }
    

// Replacing existing location


    func pinNewLocation(locationIDToReplace: String, mapString: String, mediaURL: String, latitude: String, longitude: String, completionHandlerforNewLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let newLocationURL = UdacityClient.sharedinstance().createURL(apiHost: UdacityClient.Constants.ParseApiHost, apiPath: UdacityClient.Constants.ParseApiPath, withExtension: "/\(locationIDToReplace)", parameters: nil)
        
        var headerParameters = UdacityClient.CommonJSONHeaders.jsonHeaderCommonParse
        headerParameters[UdacityClient.JSONHeaders.contentType] = UdacityClient.JSONValues.appJSON
        
        let jsonBody = "{\"uniqueKey\": \"\(UdacityClient.Constants.UdacityID)\", \"firstName\": \"\(StudentData.sharedinstance.myLocation!.firstName)\", \"lastName\": \"\(StudentData.sharedinstance.myLocation!.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        let _ = UdacityClient.sharedinstance().retrieveUdacityData(UdacityClient.Methods.put, withURL: newLocationURL, httpHeaderFieldValue: headerParameters, httpBody: jsonBody, completionHandlerForTask: {(data, error) in
            
            guard error == nil else {
                
                if (error?.description.contains("offline"))! {
                    
                    completionHandlerforNewLocation(false, NSError(domain: "pinNewLocation", code: 1, userInfo: [NSLocalizedDescriptionKey:"Internet connection is offline"]))
                
                } else {
                    
                    completionHandlerforNewLocation(false, error)
                    
                }
                
                return
                
            }
            
            
            let sessionInfo = data as! [String:AnyObject]
            
            if let _ = sessionInfo[UdacityClient.ParseResponseKeys.updatedAt] {
                
                completionHandlerforNewLocation(true, nil)
                
            } else {
                
                completionHandlerforNewLocation(false, NSError(domain: "pinNewLocation", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot replace an existing location"]))
                
            }
            
        })
    }
}
