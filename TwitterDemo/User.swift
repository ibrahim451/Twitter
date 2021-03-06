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
    var screenName: NSString?
    
    var profileUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var id: Int?
    var tweetsCount: Int?
    var likesCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        
        name = dictionary["name"] as? String
        screenName = dictionary["screenname"] as? String
        
        let profileUrlString = dictionary["profile_imager_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
            
        tagline = dictionary["name"] as? String
        
        id = dictionary["id"] as? Int
        
        tweetsCount = dictionary["statuses_count"] as? Int
        likesCount = dictionary["favourites_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        
}
   static let userDidLogoutNotification = "UserDidLogout"
    
    static  var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let userData = defaults.objectForKey("currentUserData") as? NSData
            
            if let userData = userData {
                let dictionary = try!  NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
               _currentUser = User(dictionary: dictionary)
            }
         }
            return _currentUser
        }
        set(user) {
            _currentUser = user 
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
        }
    
    
    
    

}
