//
//  EnveloppeInputs.swift
//  Enveloppe
//
//  Created by Mathieu Tan on 2018/9/21.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import Foundation


public protocol URLRepresentable {
    var path: String { get }
    var url: URL { get }
}


public protocol Envelopable: Encodable, URLRepresentable {
    associatedtype LetterType: Decodable
    
    func fetch(completion: @escaping (LetterType) -> Void)
}


public enum EnveloppeMethod: String {
    case POST
}

public protocol EnveloppeSerializable {
    func buildJSON(method: EnveloppeMethod, url: URL, data: Data) -> URLRequest
}