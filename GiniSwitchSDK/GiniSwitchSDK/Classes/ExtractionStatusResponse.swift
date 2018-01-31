//
//  ExtractionStatusResponse.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//
//

import UIKit

struct ExtractionStatusResponse: Decodable {
    
    let pages:[AddPageResponse]
    let extractionsComplete:Bool
    let links:ResponseLinks
    
    private enum CodingKeys : String, CodingKey {
        case pages = "pages"
        case extractionsComplete = "extractionsComplete"
        case links = "_links"
        case embedded = "_embedded"
    }
    
    enum EmbeddedKeys: String, CodingKey {
        case pages
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        extractionsComplete = try values.decode(Bool.self, forKey: .extractionsComplete)
        links = try values.decode(ResponseLinks.self, forKey: .links)
        let embeddedPages = try? values.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .embedded)
        pages = try embeddedPages?.decode([AddPageResponse].self, forKey: .pages) ?? []
    }

}
