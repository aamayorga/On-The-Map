//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Ansuke on 1/26/18.
//  Copyright © 2018 AM. All rights reserved.
//

extension UdacityClient {
    
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct JSONBodyKeys {
        
        // MARK: Udacity Dictionary
        static let UdacityDictionary = "udacity"
        static let UdacityUsername = "username"
        static let UdacityPassword = "password"
    }
    
    struct JSONResponseKeys {
        
        // MARK: Session ID
        static let Session = "session"
        static let SessionID = "id"
        static let Account = "account"
        static let KeyID = "key"
    }
    
    struct Methods {
        
        // MARK: Authentication
        static let Session = "/session"
        static let Users = "/users/{key}"
    }
}
