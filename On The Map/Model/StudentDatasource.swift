//
//  StudentDatasource.swift
//  On The Map
//
//  Created by Ansuke on 2/22/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class StudentDatasource: NSObject {

    var StudentInformationArray = [StudentLocation]()
    
    class func sharedInstance() -> StudentDatasource {
        struct Singleton {
            static var sharedInstance = StudentDatasource()
        }
        return Singleton.sharedInstance
    }
}
