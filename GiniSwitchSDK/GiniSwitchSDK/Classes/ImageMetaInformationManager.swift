//
//  ImageMetaInformationManager.swift
//  GiniVision
//
//  Created by Peter Pult on 27/07/16.
//  Copyright © 2016 Gini. All rights reserved.
//

import UIKit
import ImageIO
import AVFoundation
import MobileCoreServices

private var cfExifKeys: [CFString] {
    return [
        kCGImagePropertyExifLensMake,
        kCGImagePropertyExifLensModel,
        kCGImagePropertyExifISOSpeed,
        kCGImagePropertyExifISOSpeedRatings,
        kCGImagePropertyExifExposureTime,
        kCGImagePropertyExifApertureValue,
        kCGImagePropertyExifFlash,
        kCGImagePropertyExifCompressedBitsPerPixel,
        kCGImagePropertyExifUserComment
    ]
}

private var cfTiffKeys: [CFString] {
    return [
        kCGImagePropertyTIFFMake,
        kCGImagePropertyTIFFModel,
        kCGImagePropertyTIFFSoftware,
        kCGImagePropertyTIFFOrientation
    ]
}

internal extension Collection where Iterator.Element == CFString {
    
    var strings: [ String ] {
        return self.map { $0 as String }
    }
    
}

internal extension NSMutableDictionary {
    
    fileprivate var cfTopLevelKeys: [CFString] {
        return [
            kCGImagePropertyExifDictionary,
            kCGImagePropertyTIFFDictionary
        ]
    }
    
    fileprivate var stringKeys: [String] {
        return allKeys
                .map { $0 as? String }
                .flatMap { $0 }
    }
    
    func set(metaInformation value: AnyObject?, forKey key: String, inSubdictionary isSubdictionary: Bool = false) {
        // Helper method to set a value in a meta dictionary like TIFF or Exif
        func set(_ value: AnyObject?, forKey key: String, inMetaDictionaryWithKey metaDictionaryKey: String) {
            let metaDictionary = (self[metaDictionaryKey] as? NSMutableDictionary) ?? NSMutableDictionary()
            metaDictionary[key] = value
            self[metaDictionaryKey] = metaDictionary
        }
        
        // Try to set the key in the current context
        let keys = stringKeys
        if keys.contains(key) {
            setValue(value, forKey: key)
        }
        
        // Try to set in known context
        if !isSubdictionary {
            if cfExifKeys.strings.contains(key) {
                set(value, forKey: key, inMetaDictionaryWithKey: kCGImagePropertyExifDictionary as String)
            }
            if cfTiffKeys.strings.contains(key) {
                set(value, forKey: key, inMetaDictionaryWithKey: kCGImagePropertyTIFFDictionary as String)
            }
        }
        
        // Try to set in subdictioanies
        let dictionaries = allValues
            .map { $0 as? NSMutableDictionary }
            .flatMap { $0 }
        
        for dictionary in dictionaries {
            dictionary.set(metaInformation: value, forKey: key, inSubdictionary: true)
        }
    }
    
    func getMetaInformation(forKey key: String) -> AnyObject? {
        let keys = stringKeys
        guard keys.count > 0 else { return nil }
        if keys.contains(key) {
            return self[key] as AnyObject?
        }
        let dictionaries = allValues
            .map { $0 as? NSMutableDictionary }
            .flatMap { $0 }
        
        for dictionary in dictionaries {
            if let value = dictionary.getMetaInformation(forKey: key) {
                return value
            }
        }
        
        return nil
    }
    
    func filterDefaultMetaInformation() {
        let keys = [ cfExifKeys, cfTiffKeys, cfTopLevelKeys ].flatMap { $0 }.strings
        filterMetaInformation(keys)
    }
    
    /**
     Set all values to `CFNull` if the corresponding key is not in the filtered keys array.
     
     - parameter filterKeys: The keys to filter for.
     */
    func filterMetaInformation(_ filterKeys: [String]) {
        let keys = stringKeys
        for key in keys {
            if !filterKeys.contains(key) {
                self[key] = kCFNull
            } else if let dictionary = self[key] as? NSMutableDictionary {
                dictionary.filterDefaultMetaInformation()
            }
        }
    }
    
}

typealias MetaInformation = NSMutableDictionary

/// The JPEG compression level that will be used if nothing else
/// is specified in imageData(withCompression:)
let JPEGDefaultCompression:CGFloat = 0.4

final internal class ImageMetaInformationManager {
    
    var imageData: Data?
    var metaInformation: MetaInformation?
    
    // user comment fields
    let userCommentRotation = "RotDeltaDeg"
    let userCommentContentId = "ContentId"
    
    init(imageData data: Data) {
        imageData = data
        metaInformation = metaInformation(fromImageData: data)
    }
    
    func imageData(withCompression compression: CGFloat = JPEGDefaultCompression) -> Data? {
        filterMetaInformation()
        return generateImage(withMetaInformation: metaInformation, andCompression: compression)
    }
    
    func filterMetaInformation() {
        var information = metaInformation ?? MetaInformation()
        information = addDefaultValues(toMetaInformation: information)
        guard let filteredInformation = filterDefaultValues(fromMetaInformation: information) else { return }
        metaInformation = filteredInformation
    }
    
    func rotate(degrees:Int, imageOrientation: UIImageOrientation) {
        update(imageOrientation: imageOrientation)
        let information = metaInformation
        information?.set(metaInformation: userComment(rotationDegrees: degrees) as AnyObject?,
                         forKey: kCGImagePropertyExifUserComment as String)
    }
    
    func update(imageOrientation orientation: UIImageOrientation) {
        var information = metaInformation ?? MetaInformation()
        information = update(getExifOrientationFromUIImageOrientation(orientation), onMetaInformation: information)
        metaInformation = information
    }
    
    fileprivate func update(_ orientation: Int, onMetaInformation information: MetaInformation) -> MetaInformation {
        guard let updatedInformation = information.mutableCopy() as? NSMutableDictionary else { return information }
        // Set both keys in case one is changed in the future all orientations will still be set correctly
        updatedInformation.set(metaInformation: orientation as AnyObject?,
                               forKey: kCGImagePropertyTIFFOrientation as String)
        updatedInformation.set(metaInformation: orientation as AnyObject?,
                               forKey: kCGImagePropertyOrientation as String)
        return updatedInformation
    }
    
    fileprivate func addDefaultValues(toMetaInformation information: MetaInformation) -> MetaInformation {
        var defaultInformation = information
        defaultInformation = add(requiredValuesWithKeys: cfExifKeys.strings, toMetaInformation: defaultInformation)
        defaultInformation = add(requiredValuesWithKeys: cfTiffKeys.strings, toMetaInformation: defaultInformation)
        return defaultInformation
    }
    
    fileprivate func add(requiredValuesWithKeys keys: [String],
                         toMetaInformation information: MetaInformation) -> MetaInformation {
        guard let addedInformation = information.mutableCopy() as? NSMutableDictionary else { return information }
        for key in keys {
            if let _ = addedInformation.getMetaInformation(forKey: key) {
                continue
            }
            addedInformation.set(metaInformation: value(forMetaKey: key) as AnyObject, forKey: key)
        }
        return addedInformation
    }
    
    fileprivate func filterDefaultValues(fromMetaInformation information: MetaInformation) -> MetaInformation? {
        guard let filteredInformation = information.mutableCopy() as? NSMutableDictionary else { return nil }
        filteredInformation.filterDefaultMetaInformation()
        return filteredInformation as MetaInformation
    }
    
    fileprivate func generateImage(withMetaInformation information: MetaInformation?,
                                   andCompression compression: CGFloat) -> Data? {
        guard let image = imageData else { return nil }
        guard let information = information else { return nil }
        
        let targetData = NSMutableData()
        
        let destination = CGImageDestinationCreateWithData(targetData, kUTTypeJPEG, 1, nil)!
        let source = CGImageSourceCreateWithData(image as CFData, nil)
        information.setValue(compression, forKey: kCGImageDestinationLossyCompressionQuality as String)
        
        CGImageDestinationAddImageFromSource(destination, source!, 0, information as CFDictionary)
        CGImageDestinationFinalize(destination)
        return targetData as Data
    }

    fileprivate func metaInformation(fromImageData data: Data) -> MetaInformation? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
            let propertiesDict = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) else { return nil }
        return MetaInformation(dictionary: propertiesDict)
        
    }
    
    fileprivate func value(forMetaKey key: String) -> String? {
        if key == kCGImagePropertyTIFFSoftware as String {
            return UIDevice.current.systemVersion
        }
        if key == kCGImagePropertyTIFFMake as String {
            return "Apple" // Hardcoded, but a pretty safe guess
        }
        if key == kCGImagePropertyTIFFModel as String {
            return deviceName()
        }
        if key == kCGImagePropertyExifUserComment as String {
            return userComment()
        }
        
        return nil
    }
    
    fileprivate func userComment(rotationDegrees:Int? = nil) -> String {
        let platform = "iOS"
        let osVersion = UIDevice.current.systemVersion
        let uuid = imageUUID()
        var comment = "Platform=\(platform),OSVer=\(osVersion),GiniVisionVer=\(sdkVersion())," +
        "\(userCommentContentId)=\(uuid)"
        if let rotationDegrees = rotationDegrees {
            // normalize the rotation to 0-360
            let rotation = imageRotationDeltaDegrees() + rotationDegrees
            let rotationNorm = normalizedDegrees(imageRotation: rotation)
            comment += ",\(userCommentRotation)=\(rotationNorm)"
        }
        return comment
    }
    
    fileprivate func imageUUID() -> String {
        // if it already has one, reuse it - it shouldn't change
        // if not, generate it
        let existingUUID = uuidFromImage()
        return existingUUID ?? NSUUID().uuidString
    }
    
    fileprivate func imageRotationDeltaDegrees() -> Int {
        return rotationDeltaFromImage() ?? 0
    }
    
    fileprivate func uuidFromImage() -> String? {
        return self.valueFor(userCommentField: userCommentContentId)
    }
    
    fileprivate func rotationDeltaFromImage() -> Int? {
        return Int(self.valueFor(userCommentField: userCommentRotation) ?? "0")
    }
    
    fileprivate func valueFor(userCommentField:String) -> String? {
        let exifDict = metaInformation
        let existingUserComment = exifDict?.getMetaInformation(forKey:kCGImagePropertyExifUserComment as String)
        let components = existingUserComment?.components(separatedBy: ",")
        let userCommentComponent = components?.filter({ (component) -> Bool in
            return component.contains(userCommentField)
        })
        let equasionComponents = userCommentComponent?.last?.components(separatedBy: "=")
        return equasionComponents?.last
    }
    
    fileprivate func deviceName() -> String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let code = withUnsafeMutablePointer(to: &systemInfo.machine) { ptr in
            String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
        }
        return code
    }
    
    fileprivate func sdkVersion() -> String {
        let sdkBundle = Bundle(identifier: "org.cocoapods.GiniSwitchSDK")
        let version = sdkBundle?.infoDictionary?["CFBundleShortVersionString"] as? String
        return version ?? "x.x"
    }
    
    fileprivate func getExifOrientationFromUIImageOrientation(_ orientation: UIImageOrientation) -> Int {
        let number: Int
        switch orientation {
        case .up:
            number = 1
        case .upMirrored:
            number = 2
        case .down:
            number = 3
        case .downMirrored:
            number = 4
        case .left:
            number = 8
        case .leftMirrored:
            number = 7
        case .right:
            number = 6
        case .rightMirrored:
            number = 5
        }
        return number
    }
    
    fileprivate func normalizedDegrees(imageRotation:Int) -> Int {
        var normalized = imageRotation % 360
        if imageRotation < 0 {
            normalized += 360
        }
        return normalized
    }
    
}
