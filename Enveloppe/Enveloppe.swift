//
//  Enveloppe.swift
//  Enveloppe
//
//  Created by Mathieu Tan on 2018/9/18.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import Foundation


// MARK: - Interface
public class Enveloppe {
    public let session: URLSession
    public let queue: DispatchQueue
    
    public weak var errorDelegate: EnveloppeErrorDelegate?
    public var validStatusCode = Set<Int>([200])
    public var serializer: EnveloppeSerializable = EnveloppeSerializer()
    
    public init(session: URLSession = .shared, queue: DispatchQueue = .main) {
        self.session = session
        self.queue = queue
    }
    
    public func post<E: Envelopable, D: Decodable>(request: E, completion: @escaping (D) -> Void) {
        let urlRequest: URLRequest
        do {
            urlRequest = try buildRequest(request, method: .POST)
        } catch {
            self.dispatchError(EnveloppeError(underlyingError: error)); return
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let anError = error {
                self.dispatchError(EnveloppeError(underlyingError: anError)); return
            }
            guard let aResponse = response as? HTTPURLResponse else {
                self.dispatchError(.notHTTP); return
            }
            guard self.validate(statusCode: aResponse.statusCode) else {
                self.dispatchError(EnveloppeError(statusCode: aResponse.statusCode)); return
            }
            guard let aData = data else {
                self.dispatchError(.emptyData); return
            }
            
            do {
                let entity = try JSONDecoder().decode(D.self, from: aData)
                self.queue.async { completion(entity) }
            } catch {
                self.dispatchError(EnveloppeError(underlyingError: error))
            }
        }.resume()
    }
    
    public func validate(statusCode: Int) -> Bool {
        return validStatusCode.contains(statusCode)
    }
    
    public func dispatchError(_ error: EnveloppeError) {
        queue.async { [weak self] in
            self?.errorDelegate?.onError(error)
        }
    }
}


extension Enveloppe {
    func buildRequest<E: Envelopable>(_ request: E, method: EnveloppeMethod) throws -> URLRequest {
        let data = try JSONEncoder().encode(request)
        return serializer.buildJSON(method: method, url: request.url, data: data)
    }
}
