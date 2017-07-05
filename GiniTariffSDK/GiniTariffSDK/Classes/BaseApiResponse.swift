//
//  BaseApiResponse.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 09.06.17.
//
//

/*
 * BaseApiResponse is a base class that contains JSON elements present in all responses
 * received from the Switch API.
 *
 * Other responses should inherit from this class and add their additional elements
 */
public class BaseApiResponse {

    let href:String?
    
    init(href:String) {
        self.href = href
    }
    
    init(dict:JSONDictionary) {
        if let links = dict["_links"] as? JSONDictionary,
            let selfLink = links["self"] as? JSONDictionary {
            href = selfLink["href"] as? String
        }
        else {
            href = nil
        }
    }
}
