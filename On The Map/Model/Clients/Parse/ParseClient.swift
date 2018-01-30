//
//  ParseClient.swift
//  On The Map
//
//  Created by Ansuke on 1/30/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class ParseClient: NSObject {

    var session = URLSession.shared
    
    func thing() {
        let request = URLRequest(url: udacityURLFromParameters([:], withPathExtension: "/classes/StudentLocation"))
        print(request.url?.absoluteString)
    }
    
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
