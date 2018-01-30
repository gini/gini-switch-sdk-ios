//
//  AddPageResponse.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//
//

struct AddPageResponse: Codable {

    static let statusMapping = ["processing": ScanPageStatus.uploading, "processed": .analysed, "failed": .failed]
    
    let status:String
    let links:ResponseLinks
    
    private enum CodingKeys : String, CodingKey {
        case links = "_links"
        case status = "status"
    }
    
    var pageStatus:ScanPageStatus {
        if let pageStatus = AddPageResponse.statusMapping[status] {
            return pageStatus
        } else {
            return .none
        }
    }

}
