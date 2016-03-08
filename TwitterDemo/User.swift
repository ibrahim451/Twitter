//
//  User.swift
//  TwitterDemo
//
//  Created by Ibrahim Mustafa on 3/6/16.
//  Copyright © 2016 Ibrahim Mustafa. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    

    init(dictionary: NSDictionary) {
        
        
        name = dictionary["name"] as? String
        screenname = dictionary["screenname"] as? String
        
        let profileUrlString = dictionary["profile_imager_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
            
        tagline = dictionary["name"] as? String
}

}
