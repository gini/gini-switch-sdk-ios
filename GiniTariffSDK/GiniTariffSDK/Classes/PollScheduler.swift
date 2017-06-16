//
//  PollScheduler.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 16.06.17.
//
//

import UIKit

typealias PollCondition = () -> Bool
typealias PollAction = () -> Void

class PollScheduler {

    let condition:PollCondition
    let action:PollAction
    let interval:TimeInterval
    var timer:Timer? = nil
    
    init(interval:TimeInterval = 1.0, condition:@escaping PollCondition, action:@escaping PollAction) {
        self.condition = condition
        self.action = action
        self.interval = interval    // one second by default
    }
    
    deinit {
        stop()
    }
    
    func start() {
        DispatchQueue.main.async { [weak self] () in
            guard let weakSelf = self else {
                return
            }
            weakSelf.timer = Timer.scheduledTimer(timeInterval: weakSelf.interval, target: weakSelf, selector: #selector(weakSelf.onTimerTick), userInfo: nil, repeats: true)
        }
    }
    
    func stop() {
        DispatchQueue.main.async { [weak self] () in
            self?.timer?.invalidate()
            self?.timer = nil
        }
    }
    
    @objc fileprivate func onTimerTick() {
        if self.condition() {
            self.action()
        }
    }
}
