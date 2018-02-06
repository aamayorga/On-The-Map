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
    
    struct JSONResponseKeys {
        static let Results = "results"
    }
}
