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
    func retweet(tweetId: String) {
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Retweeting a tweet!")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        })
    }
    
    /**
    * POST /statuses/unretweet/
    * Params: String tweetId
    *
    * Unetweets a status (specified by the tweetId) that was already retweeted by the
    * User.
    */
    
    func unretweet(tweetId: String) {
        POST("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Unretweeting a tweet!")
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
    /**
    * POST /favorites/create/
    * Params: String tweetId
    *
    * Favorites a status (specified by the tweetId), can be a tweet owned by the User.
    */
    
    func favorite(tweetId: String) {
        POST("1.1/favorites/create.json?id=\(tweetId)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Favoriting a tweet")
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
    /**
    * POST /favorites/destroy/
    * Params: String tweetId
    *
    * Unfavorites a status (specified by the tweetId), can be a tweet owned by the User.
    */
    
    func unfavorite(tweetId: String) {
        POST("/1.1/favorites/destroy.json?id=\(tweetId)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Unfavoriting a tweet")
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
    
    //*******************
    
    
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> () ) {
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    
    
    func homeTimeLine(success: ([Tweet] -> ()), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArrays(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "Post", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                
                self.loginSuccess?()
                
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
                
                
        }
        
        
        
        
        
    }
    
}
   