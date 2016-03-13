//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Ibrahim Mustafa on 3/6/16.
//  Copyright © 2016 Ibrahim Mustafa. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: NSString?
    var timeStamp: String?
    var timestampString: NSString?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var tweetId: Int = 0
    var favoriteCount: Int = 0
    var retweetedByCurrentUser: Bool? = false
    var favoritedByCurrentUser: Bool? = false
    var wasRetweeted = false
    var wasRetweetedBy: String?
    var userId: Int?
    
    init(dictionary: NSDictionary){
        if let retweetedTweet = dictionary["retweeted_status"] {
            user = User(dictionary: (retweetedTweet["user"] as? NSDictionary)!)
            tweetId = (retweetedTweet["id"] as? Int) ?? 0
            text = retweetedTweet["text"] as? String
            retweetCount = (retweetedTweet["retweeted_count"] as? Int) ?? 0
            favoriteCount = (retweetedTweet["favorite_count"] as? Int) ?? 0
            wasRetweeted = true
            wasRetweetedBy = dictionary["user"]!["name"] as? String
            timestampString = retweetedTweet["created_at"] as? String
            userId = user?.id
            
        } else {
            user = User(dictionary: dictionary["user"] as! NSDictionary)
            tweetId = (dictionary["id"] as? Int) ?? 0
            text = dictionary["text"] as? String
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
            wasRetweeted = false
            timestampString = dictionary["created_at"] as? String
            userId = user?.id
        }
        
        retweetedByCurrentUser = dictionary["retweeted"] as? Bool
        favoritedByCurrentUser = dictionary["favorited"] as? Bool
        
        
        
        
        
        
        
        
        
        //
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.timeZone = NSTimeZone.localTimeZone()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            let times = formatter.dateFromString(timeStampString as String)?.timeIntervalSinceNow
            timeStamp = Tweet.gettingTimestamp(times!)
            
        }
        
    }
    
    
    
    
    
    
    class func tweetsWithArrays(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
            
            
        }
        
        return tweets
    }
    
    
    class func gettingTimestamp(time : NSTimeInterval) -> String {
        let timeSeconds = -Int(time)
        var timeSince: Int = 0
        
        if timeSeconds == 0 {
            return "Now"
        }
        
        if timeSeconds <= 60 {
            timeSince = timeSeconds
            return "\(timeSince)s"
        }
        
        if timeSeconds/60 < 60 {
            timeSince = timeSeconds/60
            return "\(timeSince)m"
        }
        
        if (timeSeconds/60)/60 < 24 {
            timeSince = (timeSeconds/60)/60
            return "\(timeSince)h"
        }
        
        if ((timeSeconds/60)/60)/24 < 365 {
            timeSince = ((timeSeconds/60)/60)/24
            return "\(timeSince)d"
        }
        
        if (((timeSeconds/60)/60)/24)/365 < 100 {
            timeSince = ((((timeSeconds)/60)/60)/24)/365
            return "\(timeSince)y"
        }
        
        return "\(timeSince)"
    }
    
}