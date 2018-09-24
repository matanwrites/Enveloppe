//
//  EnveloppeInputs.swift
//  Enveloppe
//
//  Created by Mathieu Tan on 2018/9/21.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import Foundation


// MARK: - Envelopable
public protocol Enveloppable: Encodable, URLRepresentable {
    associatedtype LetterType: Decodable
}


public protocol URLRepresentable {
    var path: String { get }
    var url: URL { get }
}


// MARK: - EnveloppeSerializable
public protocol EnveloppeSerializable {
    func buildJSON(method: EnveloppeMethod, url: URL, data: Data) -> URLRequest
}

public enum EnveloppeMethod: String {
    case POST
}
