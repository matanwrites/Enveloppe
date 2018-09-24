//
//  EnveloppeFetchable.swift
//  Enveloppe
//
//  Created by sintaiyuan on 9/24/18.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import Foundation


/// Provides the ability for a Enveloppe (request) to fetch its letter (content)
public protocol EnveloppeFetchable: Enveloppable {
    func fetch(client: Enveloppe, completion: @escaping (LetterType) -> Void)
}


extension EnveloppeFetchable {

    /// Provides the ability for a Enveloppe (request) to fetch its letter (content)
    ///
    /// - Parameters:
    ///   - client: an Enveloppe or Enveloppe() by default
    ///   - completion: block(self.LetterType)
    public func fetch(client: Enveloppe = Enveloppe(), completion: @escaping (LetterType) -> Void) {
        client.errorDelegate = EnveloppeErrorObserver.instance
        client.post(request: self, completion: completion)
    }
}
