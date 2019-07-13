//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Devanshu on 16/06/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation
import UIKit


// GCD Blackbox for asynchronus task

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}


