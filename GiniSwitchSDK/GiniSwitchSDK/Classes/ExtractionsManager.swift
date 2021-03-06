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

final class ExtractionsManager {
    
    var clientId:String = ""
    var clientSecret:String = ""
    var clientDomain:String = ""

    var scannedPages = PageCollection()
    var extractionsComplete = false
    var extractions:ExtractionCollection?
    var authenticator:Authenticator?
    var uploadService:ExtractionService?
    
    // polling
    var statusScheduler:PollScheduler?
    var extractionsScheduler:PollScheduler?
    
    weak var delegate:ExtractionsManagerDelegate?
    
    // if the create extraction order call comes before the client is authenticated
    // it needs to be queued. shouldRequestOrder is used for that
    var shouldRequestOrder = false
    
    var hasActiveSession:Bool {
        return (authenticator?.isLoggedIn ?? false) &&
            (uploadService?.hasExtractionOrder ?? false)
    }
    
    var isProcessing:Bool {
        return scannedPages.pages.reduce(false) { (processing, currentPage) in
            return processing || (currentPage.status != .analysed && currentPage.status != .failed)
        }
    }
    
    var hasCredentials:Bool {
        return (!clientId.isEmpty && !clientSecret.isEmpty && !clientDomain.isEmpty)
    }
    
    init(clientId:String = "", clientSecret:String = "", clientDomain:String = "") {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.clientDomain = clientDomain
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
        logger.logInfo(message: "Authenticating...")
        authenticator = Authenticator(clientId: clientId,
                                      secret: clientSecret,
                                      domain: clientDomain,
                                      credentials: KeychainCredentialsStore())
        authenticator?.authenticate(success: { [weak self] () in
            logger.logInfo(message: "Authentication successful")
            if self?.shouldRequestOrder == true {
                logger.logInfo(message: "Detected pending extraction order creation")
                self?.createExtractionOrder()
            }
        }, failure: { [weak self] (error) in
            logger.logError(message: "Authentication failed: \(error.localizedDescription)")
            let authError = NSError(errorCode: .authentication, underlyingError: error)
            self?.notifyError(authError)
        })
    }
    
    func createExtractionOrder() {
        guard authenticator?.isLoggedIn == true,
        let token = authenticator?.credentials.accessToken else {
            // not logged in
            shouldRequestOrder = true
            return
        }
        guard uploadService == nil || uploadService?.hasExtractionOrder == false else {
            return
        }
        shouldRequestOrder = false
        uploadService = ExtractionService(token: token)
        logger.logInfo(message: "Creating extraction order...")
        uploadService?.createOrder(completion: { [weak self](orderUrl, error) in
            if self?.tryHandleUnauthorizedError(error) == true {
                logger.logInfo(message: "Queueing extraction order creating")
                self?.shouldRequestOrder = true
                return
            }
            if error == nil && orderUrl != nil {
                logger.logInfo(message: "Created extraction order")
                self?.startPolling()
                self?.startQueuedUploads()
            } else {
                logger.logError(message: "Creating extraction order failed: \(String(describing: error))")
                let orderError = NSError(errorCode: .cannotCreateExtractionOrder, underlyingError:error)
                self?.notifyError(orderError)
            }
        })
    }
    
    func add(page: ScanPage) {
        // adding locally
        page.status = .taken
        if scannedPages.pages.contains(page) {
            scannedPages.remove(page)
        }
        scannedPages.add(element: page)
        notifyCollectionChanged()
        guard hasActiveSession else {
            // Queue the request. After the session is active, the uploads will be started
            return
        }
        page.status = .uploading
        logger.logInfo(message: "Uploading page")
        uploadService?.addPage(data: page.imageData, completion: { [weak self](pageUrl, error) in
            if let error = error {
                page.status = .failed
                logger.logError(message: "Page upload failed: \(error.localizedDescription)")
                self?.handleError(error, ofType: .cannotUploadPage)
            } else {
                logger.logInfo(message: "Uploaded page with path\n\(pageUrl ?? "<unknown>")")
                page.id = pageUrl
                if page.status == .deleted {
                    self?.delete(page: page)
                    return
                }
                if page.status == .replaced {
                    self?.replace(page: page, withPage: page)
                    return
                }
                page.status = .uploaded
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
                    logger.logError(message: "Page delete failed: \(error.localizedDescription)")
                    self?.handleError(error, ofType: .pageDeleteError)
                    // TODO: if deleting failed, add the pages to the scan pages array so users see that
                    // it is still there
                } else {
                    logger.logInfo(message: "Deleted page with path\n\(pageUrl ?? "<unknown>")")
                }
            })
        } else {
            page.status = .deleted
        }
    }
    
    /// Replacing handles the case where the image was rotated and needs to be re-uploaded
    func replace(page: ScanPage, withPage:ScanPage) {
        guard hasActiveSession else { return }
        
        page.imageData = withPage.imageData
        notifyCollectionChanged()
        if let id = page.id {
            uploadService?.replacePage(id: id,
                                       newImageData: withPage.imageData,
                                       completion: { [weak self] (pageUrl, error) in
                if let error = error {
                    logger.logError(message: "Page replace failed: \(error.localizedDescription)")
                    self?.handleError(error, ofType: .pageReplaceError)
                } else {
                    logger.logInfo(message: "Replaced page\n\(page.id ?? "<unknown>")")
                    page.id = pageUrl
                    page.status = .uploaded
                    self?.notifyCollectionChanged()
                }
            })
        } else {
            page.status = .replaced
        }
    }
    
    func replace(pageId:String, imageData:Data) {
        guard hasActiveSession else { return }
        uploadService?.replacePage(id: pageId, newImageData: imageData, completion: { [weak self] (pageUrl, error) in
            if let error = error {
                logger.logError(message: "Page replace failed: \(error.localizedDescription)")
                self?.handleError(error, ofType: .pageReplaceError)
            } else {
                logger.logInfo(message: "Replaced page\n\(pageId)\nwith path\n\(pageUrl ?? "<unknown>")")
            }
        })
    }
    
    func sendFeedback(_ feedback:ExtractionCollection) {
        guard hasActiveSession else { return }
        uploadService?.sendFeedback(feedback, completion: { [weak self] (error) in
            if let error = error {
                logger.logError(message: "Sending feedback failed: \(error.localizedDescription)")
                self?.handleError(error, ofType: .feedbackError)
            } else {
                logger.logInfo(message: "Feedback sent!")
                self?.notifyFeedbackSent()
            }
        })
    }
    
    func pollStatus() {
        guard hasActiveSession else { return }
        uploadService?.fetchOrderStatus(completion: { [weak self](status, error) in
            if let _ = error {
                self?.handleError(error, ofType: .pageStatusError)
            } else if let newStatus = status {
                self?.parseStatus(newStatus)
            }
        })
    }
    
    func pollExtractions() {
        guard hasActiveSession else { return }
        uploadService?.fetchExtractions(completion: { [weak self](collection, error) in
            if let _ = error {
                self?.handleError(error, ofType: .extractionsError)
            } else if let newExtractions = collection {
                self?.parseExtractions(newExtractions)
            }
        })
    }
    
    fileprivate func parseStatus(_ status:ExtractionStatusResponse?) {
        // go through all scanned pages and see if their status changed if any way
        var hasChanges = false
        let hasJustCompleted = !extractionsComplete && (status?.extractionsComplete ?? false)
        status?.pages.forEach({ (page) in
            if let pageRef = page.links.selfLink?.href,
                let scannedPage = scannedPages.page(for: pageRef) {
                if shouldChangeStatus(from:scannedPage.status, to: page.pageStatus) {
                    hasChanges = true
                    scannedPage.status = page.pageStatus
                }
            }
        })
        if hasChanges {
            logger.logInfo(message: "Order status changed!")
            notifyCollectionChanged()
        }
        if hasJustCompleted {
            logger.logInfo(message: "Extractions completed")
            extractionsComplete = true
            notifyExtractionsComplete()
        }
    }
    
    fileprivate func parseExtractions(_ collection:ExtractionCollection) {
        // see if there's something new and notify if so
        if extractions != collection {
            logger.logInfo(message: "Extractions changed!")
            extractions = collection
            notifyExtractionsChanged()
        }
    }
    
    fileprivate func notifyCollectionChanged() {
        self.delegate?.extractionsManager(self, didChangePageCollection: scannedPages)
    }
    
    fileprivate func notifyExtractionsChanged() {
        guard let extractions = extractions else {
            logger.logError(message: "Notifying that extractions are changed with a nil extractions object")
            return
        }
        self.delegate?.extractionsManager(self, didChangeExtractions: extractions)
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
        queuedPages().forEach { add(page: $0) }
    }
    
    fileprivate func queuedPages() -> [ScanPage] {
        return scannedPages.pages.filter { $0.status == .taken }
    }
    
    fileprivate func shouldChangeStatus(from:ScanPageStatus, to: ScanPageStatus) -> Bool {
        // ignore status changes for pages scheduled for deletion and
        // replacement. They might be marked as analysed, but since they
        // will be replaced soon, the status shouldn't be displayed
        return from != to && from != .replaced && from != .deleted
    }
    
}

/// Polling
extension ExtractionsManager {
    
    fileprivate func startPolling() {
        statusScheduler = PollScheduler(condition: { [weak self]() -> Bool in
            let analysingPages = self?.scannedPages.pages.filter {$0.status == .uploaded || $0.status == .uploading}
            return (self?.hasActiveSession == true) &&
                (self?.extractionsComplete == false ||
                    !(analysingPages?.isEmpty ?? true))
            }, action: { [weak self]() in
                self?.pollStatus()
        })
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
    
}

/// Error handling
extension ExtractionsManager {
    
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
