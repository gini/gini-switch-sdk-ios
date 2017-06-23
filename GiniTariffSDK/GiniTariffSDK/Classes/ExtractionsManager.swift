
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
    func extractionsManager(_ manager:ExtractionsManager, didChangeExtractions extractions:ExtractionCollection)
    func extractionsManagerDidAuthenticate(_ manager:ExtractionsManager)
    func extractionsManagerDidCreateOrder(_ manager:ExtractionsManager)
    
}

class ExtractionsManager {
    
    var clientId:String = ""
    var clientSecret:String = ""
    var clientDomain:String = ""

    var scannedPages = PageCollection()
    var extractions = ExtractionCollection()
    var authenticator:Authenticator? = nil
    var uploadService:ExtractionService? = nil
    
    // polling
    var statusScheduler:PollScheduler? = nil
    var extractionsScheduler:PollScheduler? = nil
    
    var delegate:ExtractionsManagerDelegate? = nil
    
    // if the create extraction order call comes before the client is authenticated
    // it needs to be queued. shouldRequestOrder is used for that
    var shouldRequestOrder = false
    
    var hasActiveSession:Bool {
        return (authenticator?.isLoggedIn ?? false) &&
            (uploadService?.hasExtractionOrder ?? false)
    }
    
    var hasCredentials:Bool {
        return (!clientId.isEmpty && !clientSecret.isEmpty && !clientDomain.isEmpty)
    }
    
    init() {
        importCredentials()
    }
    
    deinit {
        stopPolling()
    }
    
    func authenticate() {
        guard hasCredentials else {
            // no credentials - cannot login
            return
        }
        guard authenticator == nil else {
            // assume already trying too log in
            return
        }
        authenticator = Authenticator(clientId: clientId, secret: clientSecret, domain: clientDomain, credentials: KeychainCredentialsStore())
        authenticator?.authenticate(success: { [weak self] () in
            if self?.shouldRequestOrder == true {
                self?.createExtractionOrder()
            }
        }, failure: { (error) in
            // TODO: handle error
        })
    }
    
    func createExtractionOrder() {
        guard authenticator?.isLoggedIn == true,
        let token = authenticator?.userToken else {
            // not logged in
            shouldRequestOrder = true
            return
        }
        guard uploadService == nil else {
            return
        }
        shouldRequestOrder = false
        uploadService = ExtractionService(token: token)
        uploadService?.createOrder(completion: { [weak self](orderUrl, error) in
            self?.tryHandleUnauthorizedError(error)
            if error == nil && orderUrl != nil {
                self?.startPolling()
                self?.startQueuedUploads()
            }
        })
    }
    
    func add(page: ScanPage) {
        // adding locally
        page.status = .taken
        scannedPages.add(element: page)
        notifyCollectionChanged()
        guard hasActiveSession else {
            // Queue the request. After the session is active, the uploads will be started
            return
        }
        guard let image = page.imageData else {
            // TODO: imageData should probably not be an optional
            return
        }
        page.status = .uploading
        uploadService?.addPage(data: image, completion: { [weak self](pageUrl, error) in
            if let _ = error {
                self?.tryHandleUnauthorizedError(error)
                // TODO: handle error
            }
            else {
                page.id = pageUrl
                page.status = .uploaded
                self?.notifyCollectionChanged()
            }
        })
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
            uploadService?.deletePage(id: id, completion: { [weak self](pageUrl, error) in
                // TODO: Handle possible errors
                self?.tryHandleUnauthorizedError(error)
            })
        }
    }
    
    /// Replacing handles the case where the image was rotated and needs to be re-uploaded
    func replace(page: ScanPage, withPage:ScanPage) {
        guard hasActiveSession else {
            // TODO: queue the request
            return
        }
        
        let index = scannedPages.pages.index(of: page)
        scannedPages.remove(page)
        withPage.status = .uploading
        scannedPages.pages.insert(withPage, at: index ?? scannedPages.pages.endIndex)
        notifyCollectionChanged()
        if let id = page.id, let data = withPage.imageData {
            
            uploadService?.replacePage(id: id, newImageData: data, completion: { [weak self] (pageUrl, error) in
                self?.tryHandleUnauthorizedError(error)
                if error == nil {
                    page.id = pageUrl
                    page.status = .uploaded
                    self?.notifyCollectionChanged()
                }
            })
        }
    }
    
    func pollStatus() {
        guard hasActiveSession else {
            // TODO: queue the request
            return
        }
        uploadService?.fetchOrderStatus(completion: { [weak self](status, error) in
            if let _ = error {
                self?.tryHandleUnauthorizedError(error)
            }
            else if let newStatus = status {
                self?.parseStatus(newStatus)
            }
        })
    }
    
    func pollExtractions() {
        guard hasActiveSession else {
            // TODO: queue the request
            return
        }
        uploadService?.fetchExtractions(completion: { [weak self](collection, error) in
            if let _ = error {
                self?.tryHandleUnauthorizedError(error)
            }
            else if let newExtractions = collection {
                self?.parseExtractions(newExtractions)
            }
        })
    }
    
    fileprivate func importCredentials() {
        let sdk = TariffSdkStorage.activeTariffSdk
        clientId = sdk?.clientId ?? ""
        clientSecret = sdk?.clientSecret ?? ""
        clientDomain = sdk?.clientDomain ?? ""
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
    
    fileprivate func parseExtractions(_ collection:ExtractionCollection) {
        // see if there's something new and notify if so
        if extractions != collection {
            extractions = collection
            notifyExtractionsChanged()
        }
    }
    
    fileprivate func notifyCollectionChanged() {
        self.delegate?.extractionsManager(self, didChangePageCollection: scannedPages)
    }
    
    fileprivate func notifyExtractionsChanged() {
        self.delegate?.extractionsManager(self, didChangeExtractions: extractions)
    }
    
    fileprivate func startQueuedUploads() {
        queuedPages().forEach { (page) in
            add(page: page)
        }
    }
    
    fileprivate func startPolling() {
        statusScheduler = PollScheduler(condition: { [weak self]() -> Bool in
            return (self?.hasActiveSession == true)
        }) { [weak self]() in
            self?.pollStatus()
        }
        statusScheduler?.start()
        extractionsScheduler = PollScheduler(condition: { [weak self]() -> Bool in
            // only poll if there's an order and at least one uploaded page
            let uploadedPages = self?.scannedPages.pages.filter {$0.status == .uploaded || $0.status == .analysed}
            return (self?.hasActiveSession == true) && (uploadedPages?.isEmpty == false)
        }, action: { [weak self]() in
            self?.pollExtractions()
        })
        extractionsScheduler?.start()
    }
    
    fileprivate func stopPolling() {
        statusScheduler?.stop()
        extractionsScheduler?.stop()
        statusScheduler = nil
        extractionsScheduler = nil
    }
    
    fileprivate func queuedPages() -> [ScanPage] {
        let queued = scannedPages.pages.filter { $0.status == .taken }
        return queued
    }
    
    fileprivate func tryHandleUnauthorizedError(_ error:Error?) {
        if let error = error as NSError? {
            if error.isTokenExpiredError() {
                authenticator?.reauthenticate()
            }
        }
    }
}
