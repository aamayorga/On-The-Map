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
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?

    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[ParseClient.JSONBodyKeys.ObjectID] as? String
        uniqueKey = dictionary[ParseClient.JSONBodyKeys.UniqueKey] as? String
        firstName = dictionary[ParseClient.JSONBodyKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONBodyKeys.LastName] as? String
        mapString = dictionary[ParseClient.JSONBodyKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONBodyKeys.MediaURL] as? String
        latitude = dictionary[ParseClient.JSONBodyKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONBodyKeys.Longitude] as? Double
        createdAt = dictionary[ParseClient.JSONBodyKeys.CreatedAt] as? String
        updatedAt = dictionary[ParseClient.JSONBodyKeys.UpdatedAt] as? String
    }
}
