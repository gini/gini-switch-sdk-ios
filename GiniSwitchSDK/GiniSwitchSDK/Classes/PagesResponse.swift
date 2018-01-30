//
//  PagesResponse.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//
//

/*
 * PagesResponse is a class that contains JSON sub-elements present in the pages section
 * in many responses within the Switch API.
 */
struct PagesResponse : Codable {
    
    let links:ResponseLinks
    
    private enum CodingKeys : String, CodingKey {
        case links = "_links"
    }
    
}
