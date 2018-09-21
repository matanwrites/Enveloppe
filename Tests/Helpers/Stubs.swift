//
//  Stubs.swift
//  Tests
//
//  Created by Mathieu Tan on 2018/9/21.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import Foundation


extension URL {
    static var stub = URL(string: "https://stub.com")!
}


extension HTTPURLResponse {
    convenience init(url: URL, code: Int) {
        self.init(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
}


class URLSessionStub: URLSession {
    typealias DataTaskBlock = (Data?, URLResponse?, Error?) -> Void
    
    var completionHandler: DataTaskBlock?
    var stubResponse: ResponseStub!
    
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskBlock) -> URLSessionDataTask {
        self.completionHandler = completionHandler
        return StubTask(responseStub: stubResponse, completionHandler: completionHandler)
    }

    class StubTask: URLSessionDataTask {
        var responseStub: ResponseStub?
        let completionHandler: DataTaskBlock?
        
        init(responseStub: ResponseStub?, completionHandler: DataTaskBlock?) {
            self.responseStub = responseStub
            self.completionHandler = completionHandler
        }
        
        override func resume() {
            completionHandler?(responseStub?.data, responseStub?.response, responseStub?.error)
        }
    }

    struct ResponseStub {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        static func validResponse(url: URL, json: [String: Any]) -> ResponseStub {
            let dataStub = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let responseStub = HTTPURLResponse(url: url, code: 200)
            return ResponseStub(data: dataStub, response: responseStub, error: nil)
        }
        
        static func errorResponse(url: URL, error: Error) -> ResponseStub {
            return ResponseStub(data: nil, response: nil, error: error)
        }
        
        static func noDataResponse(url: URL) -> ResponseStub {
            let responseStub = HTTPURLResponse(url: url, code: 200)
            return ResponseStub(data: nil, response: responseStub, error: nil)
        }
        
        static func notHTTPResponse(url: URL) -> ResponseStub {
            let responseStub = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
            return ResponseStub(data: nil, response: responseStub, error: nil)
        }
        
        static func invalidStatusCode(url: URL, code: Int) -> ResponseStub {
            let responseStub = HTTPURLResponse(url: url, code: code)
            return ResponseStub(data: nil, response: responseStub, error: nil)
        }
    }
}
