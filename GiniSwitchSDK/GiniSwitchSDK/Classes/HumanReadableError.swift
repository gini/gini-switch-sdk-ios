//
//  HumanReadableError.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 19.07.17.
//
//

let humanReadableErrors:[GiniSwitchErrorCode] = [.network,
                                                 .authentication,
                                                 .cannotCreateExtractionOrder,
                                                 .cannotUploadPage,
                                                 .pageAnalysisFailed,
                                                 .pageDeleteError,
                                                 .pageReplaceError]

extension NSError {
    
    var isHumanReadable:Bool {
        let errorCode2 = GiniSwitchErrorCode(rawValue: code) ?? .unknown
        return humanReadableErrors.contains(errorCode2)
    }
    
    func humanReadableDescription() -> String {
        switch GiniSwitchErrorCode(rawValue: code) ?? .unknown {
        case .unknown:
            return NSLocalizedString("Es ist ein unbekannter Fehler aufgetreten",
                                     comment: "Decription of an unknown error")
        case .network, .authentication, .cannotCreateExtractionOrder:
            return NSLocalizedString("Es ist ein interner Fehler aufgetreten",
                                     comment: "Decription of anetwork, extraction order or authentication error")
        case .cannotUploadPage, .pageAnalysisFailed:
            return NSLocalizedString("Fehler beim Verarbeiten der Seite",
                                     comment: "Decription of a page upload or analysis error")
        case .pageDeleteError:
            return NSLocalizedString("Fehler beim Löschen der Seite",
                                     comment: "Decription for a page deletion error")
        case .pageReplaceError:
            return NSLocalizedString("Fehler beim Ersetzen der Seite",
                                     comment: "Decription for a page replacement error")
        default:
            return NSLocalizedString("Ooops! Es ist ein Fehler aufgetreten",
                                     comment: "Decription for a default error")
        }
    }
}
