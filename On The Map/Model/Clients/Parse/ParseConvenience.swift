//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Ansuke on 2/6/18.
//  Copyright © 2018 AM. All rights reserved.
//

extension ParseClient {
    
    func getStudentLocations(_ limit: Int?, skip: Int?, order: String?, completionHandlerForStudentLocations: @escaping (_ success: Bool, _ studentLocations: [[String: AnyObject]]?, _ errorString: String?) -> Void) {
        
        let parameters = [ParseClient.ParameterKeys.Limit: limit ?? 0, ParseClient.ParameterKeys.Skip: skip ?? "", ParseClient.ParameterKeys.Order: order ?? ""] as [String : AnyObject]
        
        let _ = taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (results, error) in
            
            guard (error == nil) else {
                completionHandlerForStudentLocations(false, nil, "Could not retrieve data")
                return
            }
            
            guard let resultsDict = results as? [String: AnyObject] else {
                completionHandlerForStudentLocations(false, nil, "Couldn't convert results into student dictionary")
                return
            }
            
            if let studentArray = resultsDict[ParseClient.JSONBodyKeys.Results] as? [[String: AnyObject]] {
                completionHandlerForStudentLocations(true, studentArray, nil)
            } else {
                completionHandlerForStudentLocations(false, nil, "No student locations dictionary")
            }
        }
        
        return
    }
    
    func postStudentLocation(userID: String?, firstName: String?, lastName: String?, mapString: String?, mediaURL: String?, latitude: Double, longitude: Double, completionHandlerForPostingStudentLoaction: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        let jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(userID ?? "")\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(firstName ?? "")\", \"\(ParseClient.JSONBodyKeys.LastName)\": \"\(lastName ?? "")\",\"\(ParseClient.JSONBodyKeys.MapString)\": \"\(mapString ?? "")\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(mediaURL ?? "")\",\"\(ParseClient.JSONBodyKeys.Latitude)\": \(latitude), \"\(ParseClient.JSONBodyKeys.Longitude)\": \(longitude)}"
        
        let _ = taskForPOSTMethod(ParseClient.Methods.StudentLocation, jsonBody: jsonBody) { (results, error) in
            guard error == nil else {
                completionHandlerForPostingStudentLoaction(false, error)
                return
            }
            
            guard results != nil else {
                completionHandlerForPostingStudentLoaction(false, error)
                return
            }
            
            completionHandlerForPostingStudentLoaction(true, nil)
            return
        }
    }
}
