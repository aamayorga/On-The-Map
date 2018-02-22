//
//  ParseConstants.swift
//  On The Map
//
//  Created by Ansuke on 1/30/18.
//  Copyright © 2018 AM. All rights reserved.
//

extension ParseClient {
    
    struct ParameterKeys {
        
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "Where"
        static let ObjectID = "objectId"
    }
    
    struct Constants {
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse"
    }
    
    struct Methods {
        
        static let StudentLocation = "/classes/StudentLocation"
        static let UpdateStudentLocation = "/classes/StudentLocation/{objectId}"
    }
    
    struct JSONBodyKeys {
        
        static let Results = "results"
        
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
    
    struct JSONResponseKeys {
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
}
