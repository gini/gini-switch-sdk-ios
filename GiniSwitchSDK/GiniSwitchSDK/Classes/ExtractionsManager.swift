
//
//  ExtractionsManager.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 12.06.17.
//
//

import UIKit

protocol ExtractionsManagerDelegate: class {
    
    func extractionsManager(_ manager:ExtractionsManager, didEncounterError error:NSError)
    func extractionsManager(_ manager:ExtractionsManager, didChangePageCollection collection:PageCollection)
    func extractionsManager(_ manager:ExtractionsManager, didChangeExtractions extractions:ExtractionCollection)
    func extractionsManagerDidAuthenticate(_ manager:ExtractionsManager)
    func extractionsManagerDidCreateOrder(_ manager:ExtractionsManager)
    func extractionsManagerDidCompleteExtractions(_ manager:ExtractionsManager)
    func extractionsManagerDidSendFeedback(_ manager:ExtractionsManager)
    
}

class ExtractionsManager {
    
    var clientId:String = ""
    var clientSecret:String = ""
    var clientDomain:String = ""

    var scannedPages = PageCollection()
    var extractionsComplete = false
    var extractions = ExtractionCollection()
    var authenticator:Authenticator? = nil
    var uploadService:ExtractionService? = nil
    
    // polling
    var statusScheduler:PollScheduler? = nil
    var extractionsScheduler:PollScheduler? = nil
    
    weak var delegate:ExtractionsManagerDelegate? = nil
    
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
        setupFeedbackHandler()
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
        Logger().logInfo(message: "Authenticating...")
        authenticator = Authenticator(clientId: clientId, secret: clientSecret, domain: clientDomain, credentials: KeychainCredentialsStore())
        authenticator?.authenticate(success: { [weak self] () in
            Logger().logInfo(message: "Authentication successful")
            if self?.shouldRequestOrder == true {
                Logger().logInfo(message: "Detected pending extraction order creation")
                self?.createExtractionOrder()
            }
        }, failure: { [weak self] (error) in
            Logger().logError(message: "Authentication failed: \(error.localizedDescription)")
            let authError = NSError(errorCode: .authentication, underlyingError: error)
            self?.notifyError(authError)
        })
    }
    
    func createExtractionOrder() {
        guard authenticator?.isLoggedIn == true,
        let token = authenticator?.userToken else {
            // not logged in
            shouldRequestOrder = true
            return
        }
        guard uploadService == nil || uploadService?.hasExtractionOrder == false else {
            return
        }
        shouldRequestOrder = false
        uploadService = ExtractionService(token: token)
        Logger().logInfo(message: "Creating extraction order...")
        uploadService?.createOrder(completion: { [weak self](orderUrl, error) in
            if self?.tryHandleUnauthorizedError(error) == true {
                Logger().logInfo(message: "Queueing extraction order creating")
                self?.shouldRequestOrder = true
                return
            }
            if error == nil && orderUrl != nil {
                Logger().logInfo(message: "Created extraction order")
                self?.startPolling()
                self?.startQueuedUploads()
            }
            else {
                Logger().logError(message: "Creating extraction order failed: \(String(describing: error))")
                let orderError = NSError(errorCode: .cannotCreateExtractionOrder, underlyingError:error)
                self?.notifyError(orderError)
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
        page.status = .uploading
        Logger().logInfo(message: "Uploading page")
        uploadService?.addPage(data: page.imageData, completion: { [weak self](pageUrl, error) in
            if let error = error {
                Logger().logError(message: "Page upload failed: \(error.localizedDescription)")
                page.status = .failed
                self?.handleError(error, ofType: .cannotUploadPage)
            }
            else {
                Logger().logInfo(message: "Uploaded page with path\n\(pageUrl ?? "<unknown>")")
                page.id = pageUrl
                page.status = .uploaded
                currentSwitchSdk().delegate?.switchSdk(sdk: currentSwitchSdk(), didUpload: page.imageData)
            }
            self?.notifyCollectionChanged()
        })
    }
    
    func delete(page: ScanPage) {
        // TODO: we should consider a "scheduled for deletion" state so we can recover into the
        // right state if the connection is lost, requests fail and so on.
        page.status = .none
        scannedPages.remove(page)
        notifyCollectionChanged()
        guard hasActiveSession else {
            return
        }
        if let id = page.id {      // if the page doesn't have an id, it was probably not uploaded
            uploadService?.deletePage(id: id, completion: { [weak self](pageUrl, error) in
                if let error = error {
                    Logger().logError(message: "Page delete failed: \(error.localizedDescription)")
                    self?.handleError(error, ofType: .pageDeleteError)
                    // TODO: if deleting failed, add the pages to the scan pages array so users see that
                    // it is still there
                }
                else {
                    Logger().logInfo(message: "Deleted page with path\n\(pageUrl ?? "<unknown>")")
                }
            })
        }
    }
    
    /// Replacing handles the case where the image was rotated and needs to be re-uploaded
    func replace(page: ScanPage, withPage:ScanPage) {
        guard hasActiveSession else {
            return
        }
        
        let index = scannedPages.pages.index(of: page)
        scannedPages.remove(page)
        withPage.status = .uploading
        scannedPages.pages.insert(withPage, at: index ?? scannedPages.pages.endIndex)
        notifyCollectionChanged()
        if let id = page.id {
            uploadService?.replacePage(id: id, newImageData: withPage.imageData, completion: { [weak self] (pageUrl, error) in
                if let error = error {
                    Logger().logError(message: "Page replace failed: \(error.localizedDescription)")
                    self?.handleError(error, ofType: .pageReplaceError)
                }
                else {
                    Logger().logInfo(message: "Deleted page\n\(withPage.id ?? "<unknown>")\nwith path\n\(pageUrl ?? "<unknown>")")
                    page.id = pageUrl
                    page.status = .uploaded
                    self?.notifyCollectionChanged()
                }
            })
        }
    }
    
    func sendFeedback(_ feedback:ExtractionCollection) {
        guard hasActiveSession else {
            return
        }
        
        uploadService?.sendFeedback(original: extractions, feedback: feedback, completion: { [weak self] (error) in
            if let error = error {
                Logger().logError(message: "Sending feedback failed: \(error.localizedDescription)")
                self?.handleError(error, ofType: .feedbackError)
            }
            else {
                Logger().logInfo(message: "Feedback sent!")
            }
        })
    }
    
    func pollStatus() {
        guard hasActiveSession else {
            return
        }
        uploadService?.fetchOrderStatus(completion: { [weak self](status, error) in
            if let _ = error {
                self?.handleError(error, ofType: .pageStatusError)
            }
            else if let newStatus = status {
                self?.parseStatus(newStatus)
            }
        })
    }
    
    func pollExtractions() {
        guard hasActiveSession else {
            return
        }
        uploadService?.fetchExtractions(completion: { [weak self](collection, error) in
            if let _ = error {
                self?.handleError(error, ofType: .extractionsError)
            }
            else if let newExtractions = collection {
                self?.parseExtractions(newExtractions)
            }
        })
    }
    
    fileprivate func importCredentials() {
        let sdk = currentSwitchSdk()
        clientId = sdk.clientId
        clientSecret = sdk.clientSecret
        clientDomain = sdk.clientDomain
    }
    
    fileprivate func setupFeedbackHandler() {
        currentSwitchSdk().feedbackHandler = { [weak self] (feedback) in
            self?.sendFeedback(feedback)
        }
    }
    
    fileprivate func parseStatus(_ status:ExtractionStatusResponse?) {
        // go through all scanned pages and see if their status changed if any way
        var hasChanges = false
        let hasJustCompleted = !extractionsComplete && (status?.extractionCompleted ?? false)
        status?.pages.forEach({ (page) in
            if let pageRef = page.href,
                let scannedPage = scannedPages.page(for: pageRef) {
                if scannedPage.status != page.pageStatus {
                    hasChanges = true
                    scannedPage.status = page.pageStatus
                }
            }
        })
        if hasChanges {
            Logger().logInfo(message: "Order status changed!")
            notifyCollectionChanged()
        }
        if hasJustCompleted {
            Logger().logInfo(message: "Extractions completed")
            extractionsComplete = true
            notifyExtractionsComplete()
        }
    }
    
    fileprivate func parseExtractions(_ collection:ExtractionCollection) {
        // see if there's something new and notify if so
        if extractions != collection {
            Logger().logInfo(message: "Extractions changed!")
            extractions = collection
            notifyExtractionsChanged()
        }
    }
    
    fileprivate func notifyCollectionChanged() {
        self.delegate?.extractionsManager(self, didChangePageCollection: scannedPages)
    }
    
    fileprivate func notifyExtractionsChanged() {
        self.delegate?.extractionsManager(self, didChangeExtractions: extractions)
        currentSwitchSdk().delegate?.switchSdk(sdk: currentSwitchSdk(), didExtractInfo: extractions)
    }
    
    fileprivate func notifyExtractionsComplete() {
        self.delegate?.extractionsManagerDidCompleteExtractions(self)
    }
    
    fileprivate func notifyFeedbackSent() {
        self.delegate?.extractionsManagerDidSendFeedback(self)
    }
    
    fileprivate func notifyError(_ error: NSError) {
        delegate?.extractionsManager(self, didEncounterError: error)
    }
    
    fileprivate func startQueuedUploads() {
        queuedPages().forEach { (page) in
            add(page: page)
        }
    }
    
    fileprivate func startPolling() {
        statusScheduler = PollScheduler(condition: { [weak self]() -> Bool in
            let analysingPages = self?.scannedPages.pages.filter {$0.status == .uploaded || $0.status == .uploading}
            return (self?.hasActiveSession == true) && (self?.extractionsComplete == false || !(analysingPages?.isEmpty ?? true))
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
    
    fileprivate func handleError(_ error:Error?, ofType type: GiniSwitchErrorCode) {
        let handled = tryHandleUnauthorizedError(error)
        if !handled {
            let highLevelError = NSError(errorCode: type, underlyingError: error)
            notifyError(highLevelError)
        }
    }
    
    @discardableResult fileprivate func tryHandleUnauthorizedError(_ error:Error?) -> Bool {
        if let error = error as NSError? {
            if error.isTokenExpiredError() {
                authenticator?.reauthenticate()
                return true
            }
        }
        return false
    }
}
