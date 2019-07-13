//
//  Student Data.swift
//  OnTheMap
//
//  Created by Devanshu on 16/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation
import UIKit

class StudentData: NSObject {
    
    var studentLocationArray = [StudentLocation]()
    
    var myLocation: StudentLocation?
    
    var locationExists = false
    
    static let sharedinstance = StudentData()
    
    private override init() {}
    
}
