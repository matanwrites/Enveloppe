//
//  EnveloppeOutputs.swift
//  Enveloppe
//
//  Created by Mathieu Tan on 2018/9/21.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import Foundation


public protocol EnveloppeErrorDelegate: class {
    func onError(_ error: EnveloppeError)
}

public class EnveloppeError {
    public let underlyingError: Error?
    public let statusCode: Int?
    
    init(underlyingError: Error? = nil, statusCode: Int? = nil) {
        self.underlyingError = underlyingError
        self.statusCode = statusCode
    }
    
    public static let emptyData = EnveloppeError()
    public static let notHTTP = EnveloppeError()
}
