//
//  StudentInformation.swift
//  On The Map
//
//  Created by Ansuke on 2/1/18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Float?
    let longitude: Float?
    let createdAt: String?
    let updatedAt: String?

    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Float
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Float
        createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String
    }
}
