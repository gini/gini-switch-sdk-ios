//
//  ExtractionsManager.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 12.06.17.
//
//

import UIKit

protocol ExtractionsManagerDelegate {
    
    func extractionsManager(_ manager:ExtractionsManager, didEncounterError error:Error)
    func extractionsManager(_ manager:ExtractionsManager, didChangePageCollection collection:PageCollection)
    
}

class ExtractionsManager {
    
    var clientId:String?
    var clientSecret:String?
    var clientDomain:String?

    var scannedPages = PageCollection()
    var authenticator:Authenticator? = nil
    var uploadService:ExtractionService? = nil
    
    var delegate:ExtractionsManagerDelegate? = nil
    
    var hasActiveSession:Bool {
        return (authenticator?.isLoggedIn ?? false) &&
            (uploadService?.hasExtractionOrder ?? false)
    }
    
    init() {
        importCredentials()
    }
    
    func authenticate() {
        guard authenticator?.isLoggedIn == false else {
            // already logged in
            return
        }
        guard authenticator == nil else {
            // assume already trying too log in
            return
        }
        assert(clientId != nil, "Attemptimg to authenticate without a client ID")
        assert(clientSecret != nil, "Attemptimg to authenticate without a client secret")
        assert(clientDomain != nil, "Attemptimg to authenticate without a client domain")
        authenticator = Authenticator(clientId: clientId!, secret: clientSecret!, domain: clientDomain!, credentials: KeychainCredentialsStore())
        authenticator?.authenticate()
    }
    
    func createExtractionOrder() {
        guard authenticator?.isLoggedIn == true,
        let token = authenticator?.userToken else {
            // not logged in
            // TODO: queue this request
            return
        }
        guard uploadService?.hasExtractionOrder == false else {
            // already has an order
            return
        }
        guard uploadService == nil else {
            return
        }
        uploadService = ExtractionService(token: token)
        uploadService?.createOrder(completion: { (orderUrl, error) in
            // TODO: check error
        })
    }
    
    func add(page: ScanPage) {
        // adding locally
        page.status = .uploading
        scannedPages.add(element: page)
        notifyCollectionChanged()
        guard hasActiveSession else {
            // TODO: queue the request
            return
        }
        guard let image = page.imageData else {
            // TODO: imageData should probably not be an optional
            return
        }
        uploadService?.addPage(data: image, completion: { [weak self](pageUrl, error) in
            if let _ = error {
                // TODO: handle error
            }
            else {
                page.id = pageUrl
                page.status = .uploaded
                self?.notifyCollectionChanged()
            }
        })
    }
    
    /// Replacing handles the case where the mage was rotated and needs to be re-uploaded
    func replace(page: ScanPage, with otherPage: ScanPage) {
        // TODO: implement me
    }
    
    func delete(page: ScanPage) {
        guard hasActiveSession else {
            // TODO: queue the request
            return
        }
        page.status = .none
        scannedPages.remove(page)
        notifyCollectionChanged()
        if let id = page.id {      // if the page doesn't have an id, it was probably not uploaded
            uploadService?.deletePage(id: id, completion: { (pageUrl, error) in
                // TODO: Handle possible errors
            })
        }
    }
    
    func pollStatus() {
        guard hasActiveSession else {
            // TODO: queue the request
            return
        }
        uploadService?.fetchExtractionStatus(completion: { (status, error) in
            if let _ = error {
                
            }
            else if let newStatus = status {
                parseStatus(newStatus)
            }
        })
    }
    
    fileprivate func importCredentials() {
        let sdk = TariffSdkStorage.activeTariffSdk
        clientId = sdk?.clientId
        clientSecret = sdk?.clientSecret
        clientDomain = sdk?.clientDomain
    }
    
    fileprivate func parseStatus(_ status:ExtractionStatusResponse?) {
        // go through all scanned pages and see if their status changed if any way
        var hasChanges = false
        status?.pages.forEach({ (page) in
            if let scannedPage = scannedPages.page(for: page.href!) {  // TODO: why is href optional?
                if scannedPage.status != page.pageStatus {
                    hasChanges = true
                    scannedPage.status = page.pageStatus
                }
            }
        })
        if hasChanges {
            notifyCollectionChanged()
        }
    }
    
    fileprivate func notifyCollectionChanged() {
        self.delegate?.extractionsManager(self, didChangePageCollection: scannedPages)
    }
}
