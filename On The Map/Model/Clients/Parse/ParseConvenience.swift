//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Ansuke on 2/6/18.
//  Copyright © 2018 AM. All rights reserved.
//

extension ParseClient {
    
    func getStudentLocations(_ limit: Int, skip: Int, order: String, completionHandlerForStudentLocations: @escaping (_ success: Bool, _ studentLocations: [[String: AnyObject]]?, _ errorString: String?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        let _ = taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (results, error) in
            
            guard (error == nil) else {
                completionHandlerForStudentLocations(false, nil, "Could not retrieve data")
                return
            }
            
            guard let resultsDict = results as? [String: AnyObject] else {
                completionHandlerForStudentLocations(false, nil, "Couldn't convert results into student dictionary")
                return
            }
            
            if let studentArray = resultsDict[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                completionHandlerForStudentLocations(true, studentArray, nil)
            } else {
                completionHandlerForStudentLocations(false, nil, "No student locations dictionary")
            }
        }
        
        return
        
    }
}
