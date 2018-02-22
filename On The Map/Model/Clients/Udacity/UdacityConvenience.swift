//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Ansuke on 1/26/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

extension UdacityClient {
    
    func authenticateWithViewController(_ hostViewController: UIViewController, username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getSessionID(username, password: password) { (success, sessionID, userID, errorString) in
            if success {
                self.sessionID = sessionID
                self.userID = userID
            }
            
            completionHandlerForAuth(success, errorString)
        }
    }
    
    func getPublicUserData(_ userId: String, completionHandlerForUserData: @escaping (_ success: Bool, _ response: [String: AnyObject]?, _ error: Error?) -> Void) {
        
        var mutableMethod = Methods.Users
        mutableMethod = substituteKeyInMethod(mutableMethod, key: UdacityClient.JSONResponseKeys.KeyID, value: UdacityClient.sharedInstance().userID!)!
        
        let _ = taskForGETMethod(mutableMethod, parameters: [:]) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForUserData(false, nil, error)
                return
            }
            
            guard let userInfo = result else {
                completionHandlerForUserData(false, nil, error)
                return
            }
            
            let userDictionary = userInfo["user"] as! [String: AnyObject]
            
            completionHandlerForUserData(true, userDictionary, nil)
        }
    }
    
    private func getSessionID(_ username: String, password: String, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ userID: String?, _ errorString: String?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.UdacityDictionary)\": {\"\(UdacityClient.JSONBodyKeys.UdacityUsername)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.UdacityPassword)\": \"\(password)\"}}"
        
        let _ = taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            var sessionNumber = String()
            
            guard (error == nil) else {
                completionHandlerForSession(false, nil, nil, "Failure to connect")
                return
            }
            
            guard (results != nil) else {
                completionHandlerForSession(false, nil, nil, "No data was returned")
                return
            }
            
            // Get Session ID
            guard let sessionDict = results![UdacityClient.JSONResponseKeys.Session] as? AnyObject else {
                completionHandlerForSession(false, nil, nil, "Login Failed (No Session Dictionary).")
                return
            }
            
            if let sessionID = sessionDict[UdacityClient.JSONResponseKeys.SessionID] as? String {
                sessionNumber = sessionID
            } else {
                completionHandlerForSession(false, nil, nil, "Login Failed (No Session ID Found)")
            }
            
            // Get User ID
            guard let accountDict = results![UdacityClient.JSONResponseKeys.Account] as? AnyObject else {
                completionHandlerForSession(false, nil, nil, "Login Failed (No Account Dictionary).")
                return
            }
            
            if let userID = accountDict[UdacityClient.JSONResponseKeys.KeyID] as? String {
                completionHandlerForSession(true, sessionNumber, userID, nil)
            } else {
                completionHandlerForSession(false, nil, nil, "Login Failed (No User ID Found)")
            }
        }
    }
}
