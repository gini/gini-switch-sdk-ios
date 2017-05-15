//
//  ScanPage.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 15.05.17.
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
}

class ScanPage {
    
    static var thumbSize = 100
    
    var thumbnail:UIImage? = nil
    var imageData:Data? = nil
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
        guard let data = imageData else { return }
        let imagesSource = CGImageSourceCreateWithData(data as CFData, nil)
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
