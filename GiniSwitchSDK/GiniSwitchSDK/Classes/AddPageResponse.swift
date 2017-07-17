//
//  AddPageResponse.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//
//


class AddPageResponse: BaseApiResponse {

    static let statusMapping = ["processing": ScanPageStatus.uploading, "processed": .analysed, "failed": .failed]
    
    let status:String?  // TODO: the status should be mandatory
    
    override init(dict: JSONDictionary) {
        status = dict["status"] as? String
        super.init(dict: dict)
    }
    
    var pageStatus:ScanPageStatus {
        if let status = self.status,
            let pageStatus = AddPageResponse.statusMapping[status] {
            return pageStatus
        }
        else {
            return .none
        }
    }

}
