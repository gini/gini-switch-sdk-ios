//
//  ExtractionCollection+Feedback.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.08.17.
//
//

import Foundation

extension ExtractionCollection {
    
    func feedbackJson() -> Data {
        let jsonEncoder = JSONEncoder()
        let feedbackData = try? jsonEncoder.encode(self)
        return feedbackData ?? Data()
    }
    
}
