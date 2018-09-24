//
//  EnveloppeErrorObserver.swift
//  Enveloppe
//
//  Created by sintaiyuan on 9/24/18.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import Foundation


public class EnveloppeErrorObserver {
    public static let instance = EnveloppeErrorObserver()
    private init () {}

    public static let errorReceived = Notification.Name(rawValue: "EnveloppeErrorObserver.errorReceived")

    public private(set) var errors = [EnveloppeError]()
}


// Commands
extension EnveloppeErrorObserver {
    /// Consume an error from the errors queue.
    /// Not thread safe (for now) always call this from the same serial queue such as the main queue
    /// - Returns: EnveloppeError or nil
    public func consumeNextError() -> EnveloppeError? {
        return errors.isEmpty ? nil : errors.removeFirst()
    }

    /// Clear all errors from the queue.
    /// Not thread safe (for now) always call this from the same serial queue such as the main queue
    public func flush() {
        errors.removeAll()
    }

    /// Push an error into the queue
    /// Not thread safe (for now) always call this from the same serial queue such as the main queue
    public func produceError(_ error: EnveloppeError) {
        errors.append(error)

        NotificationCenter.default.post(name: EnveloppeErrorObserver.errorReceived, object: self)
    }
}


extension EnveloppeErrorObserver: EnveloppeErrorDelegate {
    public func onError(_ error: EnveloppeError) {
        produceError(error)
    }
}
