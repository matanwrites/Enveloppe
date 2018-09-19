//
//  Enveloppe.swift
//  Enveloppe
//
//  Created by Mathieu Tan on 2018/9/18.
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


public class Enveloppe {
    public let session: URLSession
    public let queue: DispatchQueue
    
    public init(session: URLSession = .shared, queue: DispatchQueue = .main) {
        self.session = session
        self.queue = queue
    }
    
    public func post<E: Envelopable, T: Decodable>(request: E, completion: @escaping (T) -> Void) {
        let urlRequest = buildRequest(method: .POST, url: request.url)
        
        session.dataTask(with: urlRequest).resume()
    }
    
    public var extendURLRequest: ((inout URLRequest) -> Void)?
}


extension Enveloppe {
    func buildRequest(method: URLRequest.Method, url: URL) -> URLRequest {
        var request = URLRequest.buildJSON(method: method, url: url)
        extendURLRequest?(&request)
        return request
    }
}
