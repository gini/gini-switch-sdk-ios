//
//  ScanPage.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 15.05.17.
//
//

import UIKit
import ImageIO

enum ScanPageStatus {
    case none
    case taken
    case uploading
    case failed
    case uploaded
    case analysed
    case deleted
    case replaced
}

class ScanPage {
    
    static var thumbSize = 100
    
    var thumbnail:UIImage? = nil
    var imageData:Data = Data()
    var id:String? = nil
    var status = ScanPageStatus.none
    
    init() {
        
    }

    init(imageData data:Data, id:String? = nil, status:ScanPageStatus = .none) {
        imageData = data
        self.id = id
        self.status = status
        generateThumbnail()
    }
    
    func generateThumbnail() {
        let imagesSource = CGImageSourceCreateWithData(imageData as CFData, nil)
        guard let source = imagesSource else {return}
        let imageOptions:[String: AnyObject] = [kCGImageSourceShouldAllowFloat as String: true as NSNumber,
                                                kCGImageSourceCreateThumbnailWithTransform as String: true as NSNumber,
                                                kCGImageSourceCreateThumbnailFromImageAlways as String: true as NSNumber,
                                                kCGImageSourceThumbnailMaxPixelSize as String: ScanPage.thumbSize as NSNumber]
        let thumbnailImage = CGImageSourceCreateThumbnailAtIndex(source, 0, imageOptions as CFDictionary)
        guard let cgThumb = thumbnailImage else { return }
        thumbnail = UIImage(cgImage: cgThumb)
    }
}

extension ScanPage: Equatable {
    
    public static func ==(lhs: ScanPage, rhs: ScanPage) -> Bool {
        return lhs.imageData == rhs.imageData && lhs.id == rhs.id && lhs.status == rhs.status
    }
    
}

extension ScanPage: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        return ScanPage(imageData: self.imageData, id: self.id, status: self.status)
    }
    
}
