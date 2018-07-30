//
//  ReachabilityManager.swift
//  IOSAssessmentApp
//
//  Created by HarithaReddy on 30/07/18.
//  Copyright © 2018 administrator. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
    let reachability = Reachability()!
    class var sharedInstance : ReachabilityManager  {
        
        struct Static {
            static let instance = ReachabilityManager()
        }
        return Static.instance
        
    }
    
    func isNetworkAvailable() -> Bool
    {
        // if the connection is neither wifi nor cellular
        if reachability.connection == .none
        {
            return false
        }else
        {
            return true
        }
        
    }
    
    

}
