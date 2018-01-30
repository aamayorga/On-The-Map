//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Ansuke on 1/26/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

extension UdacityClient {
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getSessionID("lol@lol.com", password: "abcd") { (success, sessionID, errorString) in
            if success {
                print(sessionID!)
            }
        }
        
        
    }
    
    private func getSessionID(_ username: String, password: String, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.UdacityDictionary)\": {\"\(UdacityClient.JSONBodyKeys.UdacityUsername)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.UdacityPassword)\": \"\(password)\"}}"
        
        let _ = taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            guard (error == nil) else {
                completionHandlerForSession(false, nil, "Login Failed (Session ID).")
                return
            }
            
            guard let sessionDict = results![UdacityClient.JSONResponseKeys.Session] as? AnyObject else {
                completionHandlerForSession(false, nil, "Login Failed (No Session Dictionary).")
                return
            }
            
            if let sessionID = sessionDict[UdacityClient.JSONResponseKeys.SessionID] as? String {
                completionHandlerForSession(true, sessionID, nil)
            } else {
                completionHandlerForSession(false, nil, "No Session ID Found")
            }
        }
    }
}
