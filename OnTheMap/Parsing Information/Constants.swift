//
//  ParsingConstants.swift
//  OnTheMap
//
//  Created by Devanshu on 16/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        
        // URLS broken into static objects along with certain constants
        
        static let ApiScheme = "https"
        static let ParseApiHost = "parse.udacity.com"
        static let UdacityApiHost = "www.udacity.com"
        static let ParseApiPath = "/parse/classes/StudentLocation"
        static let UdacityApiPath = "/api"
        static let ParseAPILimit = "limit"
        static let LimitLocations = 100
        static let ParseAPIOrder = "order"
        static let UdacityID = "10753318794"

    }
    
    struct JSONHeaders {
        
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let ParseREST = "X-Parse-REST-API-Key"
        static let ParseAppID = "X-Parse-Application-Id"
        static let xsrfToken = "X-XSRF-TOKEN"
    
    }
    
    struct JSONValues {
        
        
        static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let appJSON = "application/json"
        
    }
    
    struct CommonJSONHeaders {
        
        static let jsonHeaderCommonParse = [JSONHeaders.ParseREST:JSONValues.restAPIKey,
                                            JSONHeaders.ParseAppID:JSONValues.parseAppID]
        
    }
    
    enum Methods: String {
        
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        
    }
    
    // Student Location keys
    
    struct ParseResponseKeys {
        
        static let results = "results"
        static let objectID = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        
    }
    
    struct UdacityResponseKeys {
        
        static let session = "session"
        static let id = "id"
        static let account = "account"
        static let registered = "registered"
        static let key = "key"
        
    }
    
    struct UserData {
        
        static let user = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
        
    }
    
    struct MapConstants {
        
        static let mapViewFineScale: Double = 50000
        static let mapViewLargeScale: Double = 500000
        static let defaultLatitude = 28.617116
        static let defaultLongitude = 77.208119
        static let defaultMediaURL = "https://www.google.co.in"
        static let pinReusableIdentifier = "locationPin"
        
    }

}
