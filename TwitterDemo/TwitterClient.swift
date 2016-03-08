//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Ibrahim Mustafa on 3/7/16.
//  Copyright © 2016 Ibrahim Mustafa. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance =  TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "oHmS8FJGJcjKZHonJnw5HlbqZ", consumerSecret: "iybpz6iE62UiAs08txHycNeCDq7eAK5N7ItPzwmEpP8xDPrSmh")
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
  
    func login(success: () ->(), failure: (NSError) -> () ) {
        loginSuccess = success
        loginFailure = failure
        
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL (string: "myytwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
           
            self.loginSuccess?()
            
        }) { (error: NSError!) -> Void in
                print ("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        
        }
        
        
    }
    
    func homeTimeLine (success: ([Tweet])->(), failure: (NSError) -> () ) {
        
        GET("1.1/statuses/home_timeline.json",parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
  
    }
    
    func currentAccount() {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            
            
            print ("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print ("profileurl: \(user.profileUrl)")
            print("description: \(user.tagline)")
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                
                
                
        })
    }
    

    
}
