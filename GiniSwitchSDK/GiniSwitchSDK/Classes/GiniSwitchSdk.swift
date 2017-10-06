//
//  GiniSwitchSdk.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//
//

import UIKit

public protocol GiniSwitchSdkDelegate: class {
    
    func switchSdk(_ sdk:GiniSwitchSdk, didChangeExtractions extractions:ExtractionCollection)
    func switchSdk(_ sdk:GiniSwitchSdk, didReceiveError error:NSError)
    func switchSdkDidCancel(_ sdk:GiniSwitchSdk)
    func switchSdkDidComplete(_ sdk:GiniSwitchSdk)
    func switchSdkDidSendFeedback(_ sdk:GiniSwitchSdk)
    
}

public class GiniSwitchSdk {
    
    /// The client ID you got from Gini GmbH
    public let clientId: String
    /// The client secret, securing your account, provided by Gini GmbH
    public let clientSecret: String
    /// Your domain. Will be used when creating new users
    public let clientDomain: String
    
    /// The delegate object, receiving callbacks about events happening in the SDK
    public weak var delegate:GiniSwitchSdkDelegate? = nil
    
    /// Contains some configuration objects that can be used to customize the SDK
    public var configuration = GiniSwitchConfiguration()
    
    /*
     * Indicates that the SDK is currently processing images (or not).
     * "Processing" might mean uploading or analysing the image.
     * Additionally, images currently being reviewed are also considered processing.
     * Images marked as "failed", are NOT considered processing.
     */
    public var isProcessing:Bool {
        return extractionsManager.isProcessing
    }
    
    let extractionsManager:ExtractionsManager
    var coordinator:MultiPageCoordinator? = nil
    
    /*
     * The extractions that have been received so far. 
     */
    var extractions:ExtractionCollection = ExtractionCollection()
    
    /*
     * Creates a GiniSwitchSdk instance based on the provided credentials
     */
    public init(clientId: String = "", clientSecret: String = "", domain: String = "") {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.clientDomain = domain
        extractionsManager = ExtractionsManager(clientId: clientId, clientSecret: clientSecret, clientDomain: clientDomain)
        extractionsManager.delegate = self
    }
    
    /*
     * Convenience method for creating the SDK's UI
     */
    public func instantiateSwitchViewController() -> UIViewController {
        coordinator = MultiPageCoordinator(extractionsManager: extractionsManager, onboarding: configuration.onboarding)
        coordinator?.delegate = self
        return coordinator!.initialViewController
    }
    
    public func sendFeedback(_ feedback:ExtractionCollection) {
        extractionsManager.sendFeedback(feedback)
    }

}

extension GiniSwitchSdk: ExtractionsManagerDelegate {
    
    func extractionsManager(_ manager:ExtractionsManager, didEncounterError error:NSError) {
        // check if it's an error that needs to be shown to the user
        if error.isHumanReadable {
            coordinator?.displayError(error)
        }
        delegate?.switchSdk(self, didReceiveError: error)
    }
    
    func extractionsManager(_ manager:ExtractionsManager, didChangePageCollection collection:PageCollection) {
        coordinator?.refreshPagesCollectionView()
    }
    
    func extractionsManager(_ manager:ExtractionsManager, didChangeExtractions extractions:ExtractionCollection) {
        self.extractions = extractions
        delegate?.switchSdk(self, didChangeExtractions: extractions)
    }
    
    func extractionsManagerDidAuthenticate(_ manager:ExtractionsManager) {
        
    }
    
    func extractionsManagerDidCreateOrder(_ manager:ExtractionsManager) {
        
    }
    
    func extractionsManagerDidCompleteExtractions(_ manager:ExtractionsManager) {
        // Don't interrupt the user immediately. Allow them to complete the last action
        // before notifying them that extractions are complete
        coordinator?.extractionsCompleted = true
    }
    
    func extractionsManagerDidSendFeedback(_ manager:ExtractionsManager) {
        delegate?.switchSdkDidSendFeedback(self)
    }
    
}

extension GiniSwitchSdk: MultiPageCoordinatorDelegate {
    
    func multiPageCoordinatorDidComplete(_ coordinator:MultiPageCoordinator) {
        delegate?.switchSdkDidComplete(self)
    }
    
    func multiPageCoordinatorDidCancel(_ coordinator:MultiPageCoordinator) {
        delegate?.switchSdkDidCancel(self)
    }
    
}
