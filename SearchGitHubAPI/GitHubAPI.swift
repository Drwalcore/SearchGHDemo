//
//  GitHubAPI.swift
//  SearchGitHubAPI
//
//  Created by Michał Czerniakowski on 07.11.2016.
//  Copyright © 2016 Michał Czerniakowski. All rights reserved.
//

import Foundation

//For Unit Test purposes only - they're not private

let gitRepoURL = "https://api.github.com/search/repositories"
let gitUserURL = "https://api.github.com/search/users"

private let clientId: String? = nil
private let clientSecret: String? = nil

class GitHubAPI {
    
    var name: String?
    var description: String?
    var ownerLogin: String?
    var ownerAvatarURL: String?
    var stars: Int?
    var forks: Int?
    
    
    
    init (parsedJSON: NSDictionary) {
        
        if let name = parsedJSON["name"] as? String {
            self.name = name
        }
        
        if let description = parsedJSON["description"] as? String {
            self.description = description
        }
        
        if let owner = parsedJSON["owner"] as? NSDictionary {
            
            if let ownerLogin = owner["login"] as? String {
                self.ownerLogin = ownerLogin
            }
            
            if let ownerAvatarURL = owner["avatar_url"] as? String {
                self.ownerAvatarURL = ownerAvatarURL
            }
        }
        
        if let stars = parsedJSON["stargazers_count"] as! Int? {
            self.stars = stars
        }
        
        
        if let forks = parsedJSON["forks_count"] as! Int? {
            self.forks = forks
        }
        
    }
    
    class func startRepoFetch(settings: GitHubAPIConditions, successCallback: @escaping ([GitHubAPI]) -> Void, error: ((NSError?) -> Void)?) -> AFHTTPRequestOperation {
        
        let manager = AFHTTPRequestOperationManager()
        let params = queryParamsWithSettings(settings: settings)
        
        let operation = manager.get(gitRepoURL, parameters: params, success: { (operation ,responseObject) -> Void in
            
            if let fetchResults = (responseObject as AnyObject)["items"] as? NSArray {
                
                var repositories: [GitHubAPI] = []
                
                for singleResult in fetchResults as! [NSDictionary] {
                    repositories.append(GitHubAPI(parsedJSON: singleResult))
                }
                
                successCallback(repositories)
            }
            
            }, failure: { (operation, requestError) -> Void in
                
                if let errorCallback = error {
                    errorCallback(requestError as NSError?)
                }
        })
        return operation!
    }
    
    class func startUsersFetch(settings: GitHubAPIUsers, successCallback: @escaping ([User]) -> Void, error: ((NSError?) -> Void)?) -> AFHTTPRequestOperation {
        
        let manager = AFHTTPRequestOperationManager()
        let parameters = queryParamsWithSettings(settings: settings)
        
        let operation = manager.get(gitUserURL,
                    parameters: parameters,
                    success: { (operation, responseObject) in
                        
                        if let fetchResults = (responseObject as AnyObject)["items"] as? [[String: AnyObject]] {
                            
                            var users: [User] = []
                            
                            for singleResult in fetchResults {
                                let user = User()
                                user.login = singleResult["login"] as? String
                                user.repoURL = singleResult["html_url"] as? String
                                user.avatarURL = singleResult["avatar_url"] as? String
                                user.score = (singleResult["score"] as? Double) ?? 0
                                users.append(user)
                            }
                            successCallback(users)
                        }
            }, failure: { (operation, requestError) -> Void in
                
                if let errorCallback = error {
                    errorCallback(requestError as NSError?)
                }

        })
        return operation!
    }
    
    private class func queryParamsWithSettings(settings: GitHubAPIUsers) -> [String: String] {
        var params = baseQuery()
        let q = settings.searchString ?? ""
        params["q"] = q
        params["sort"] = "followers"
        params["order"] = "desc"
        return params
    }
    
    class func baseQuery() -> [String: String] {
        var params: [String:String] = [:]
        
        if let clientId = clientId {
            params["client_id"] = clientId
        }
        
        if let clientSecret = clientSecret {
            params["client_secret"] = clientSecret
        }
        return params
    }
    
    private class func queryParamsWithSettings(settings: GitHubAPIConditions) -> [String: String] {
        
        var params = baseQuery()
        
        var q = ""
        
        if let searchString = settings.searchString {
            q = q + searchString
        }
        
        q = q + " stars:>\(settings.minStars)"
        
        params["q"] = q
        params["sort"] = "stars"
        params["order"] = "desc"
        
        return params;
    }
}
