//
//  PagesResponse.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 09.06.17.
//
//

/*
 * PagesResponse is a class that contains JSON sub-elements present in the pages section
 * in many responses within the Switch API.
 */
class PagesResponse {
    
    let href:String?
    
    init(href:String) {
        self.href = href
    }
    
    init(dict:JSONDictionary) {
        if let links = dict["_links"] as? JSONDictionary,
            let pages = links["pages"] as? JSONDictionary {
            href = pages["href"] as? String
        }
        else {
            href = nil
        }
    }
    
}
