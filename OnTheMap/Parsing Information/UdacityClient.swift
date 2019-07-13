
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Devanshu on 16/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import UIKit
import Foundation

class UdacityClient: NSObject {
    
    var sessionID: String? = nil
    var userID: String? = nil
    
    // A template function to retrieve information that uses get, post, delete and put methods
    
    func retrieveUdacityData(_ method: Methods, withURL url: URL, httpHeaderFieldValue httpHeader: [String:String], httpBody: String?, completionHandlerForTask: @escaping (_ result: AnyObject?, _ error: NSError?) throws -> Void ) -> URLSessionDataTask {
    
        // Making URL Request
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        for (field, value) in httpHeader {
            
            request.addValue(value, forHTTPHeaderField: field)
            
        }
        
        if let httpBody = httpBody {
            
            request.httpBody = httpBody.data(using: String.Encoding.utf8)
            
        }
        
        // Sending the request
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            // Creating an error function template
            
            func sendError(_ error: String) {
                
                print(error)
                
                let userInfo = [NSLocalizedDescriptionKey:error]
                
                try! completionHandlerForTask(nil, NSError(domain: "retrieveUdacityData", code: 1, userInfo: userInfo))
                
            }
            
            // Checking for error in returned data
            
            guard error == nil else {
                
                sendError("Request returned the following error: \(error!)")
                
                return
                
            }
            
            // Checking for status code
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    
                    switch statusCode {
                    case 403: sendError("Forbidden: wrong username/password")
                    case 404: sendError("Not found")
                    case 405: sendError("Method not allowed")
                    default: sendError("Bad status code: \(statusCode)")
                        
                    }
                    
                } else {
                    
                    sendError("Request returned an error not in the range of 200")
                    
                }
                
                return
                
            }
            
            // Check for if data is returned or not
            
            guard var returnedData = data else {
                
                sendError("Request returned no data")
                return
                
            }
            
            if url.description.contains("www.udacity.com/api") {
                
                let range = Range(5 ..< returnedData.count)
                returnedData = returnedData.subdata(in: range)
                
            }
            
            var serializedData: AnyObject! = nil
            
            do {
                
                serializedData = try JSONSerialization.jsonObject(with: returnedData, options: .allowFragments) as AnyObject
                try! completionHandlerForTask(serializedData, nil)
                
            } catch {
                
                sendError("Could not parse returned data")
                return
                
            }})
        
        task.resume()
        
        return task
        
    }
    
    // Creating URL
    
    func createURL(apiHost: String, apiPath: String, withExtension pathExtension: String?, parameters: [String:String]?) -> URL {
        
        var udacityURL = URLComponents()
        
        udacityURL.scheme = Constants.ApiScheme
        udacityURL.host = apiHost
        udacityURL.path = apiPath + (pathExtension ?? "")
        udacityURL.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            
            for (key, value) in parameters {
                
                let queryitem = URLQueryItem(name: key, value: value)
                udacityURL.queryItems!.append(queryitem)
                
            }
            
        }
        
        return udacityURL.url!
        
    }
    
    
    // Creating a shared instance
    
    class func sharedinstance() -> UdacityClient {
        
        struct Singleton {
            
            static var sharedinstance = UdacityClient()
            
        }
        
        return Singleton.sharedinstance
        
    }
    
}
