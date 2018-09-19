//
//  URLRequest.swift
//  Enveloppe
//
//  Created by Mathieu Tan on 2018/9/18.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import Foundation

extension URLRequest {
    enum Method: String {
        case POST
        case GET
    }
    
    static func buildJSON(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
