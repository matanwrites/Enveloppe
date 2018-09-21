//
//  EnveloppeTests.swift
//  Tests
//
//  Created by Mathieu Tan on 2018/9/18.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import XCTest
import Enveloppe


class EnveloppeTests: XCTestCase, EnveloppeErrorDelegate {
    
    var sut: Enveloppe!
    var sessionStub: URLSessionStub!
    var queue = DispatchQueue(label: #file)
    var errorReceived: EnveloppeError!

    override func setUp() {
        super.setUp()
        sessionStub = URLSessionStub()
        sut = Enveloppe(session: sessionStub, queue: queue)
        sut.errorDelegate = self
    }
    
    override func tearDown() {
        super.tearDown()
        errorReceived = nil
    }
    
    func onError(_ error: EnveloppeError) {
        errorReceived = error
    }
}


// MARK: - Serialization Tests
extension EnveloppeTests {
    func test_buildRequest_delegates_to_serializer() {
        let serializer = EnveloppeSerializerMock()
        sut.serializer = serializer
        let url = URL.stub
        let enveloppe = EnveloppeStub(path: url.absoluteString, url: url)
        let data = try! JSONEncoder().encode(enveloppe)
        
        let completion: (LetterStub) -> Void = { _ in }
        
        sut.post(request: enveloppe, completion: completion)
        syncQueue(queue)
        XCTAssertEqual(serializer.data, data)
    }
}


// MARK: - Deserialization Tests
extension EnveloppeTests {
    func test_whenInput_valid_outputLetterEntity() {
        let url = URL.stub
        let content = "somestring"
        let enveloppe = EnveloppeStub(path: url.absoluteString, url: url)
        sessionStub.completionHandler = nil
        
        let completion: (LetterStub) -> Void = {
            XCTAssertEqual(content, $0.content)
        }
        
        sut.post(request: enveloppe, completion: completion)
        syncQueue(queue)
    }
    
    func test_whenInput_invalid_outputError() {
        let url = URL.stub
        let content = "somestring"
        let enveloppe = EnveloppeStub(path: url.absoluteString, url: url)
        sessionStub.stubResponse = URLSessionStub.ResponseStub.validResponse(url: enveloppe.url, json: ["wrongkey":content])
        
        let completion: (LetterStub) -> Void = {
            XCTAssertEqual(content, $0.content)
        }
        
        sut.post(request: enveloppe, completion: completion)
        syncQueue(queue)
        XCTAssertTrue(errorReceived!.underlyingError! is DecodingError)
    }
}


// MARK: - Error handling
extension EnveloppeTests {
    func test_whenInput_error() {
        let url = URL.stub
        let enveloppe = EnveloppeStub(path: url.absoluteString, url: url)
        let error = NSError(domain: "bla", code: -42, userInfo: nil)
        sessionStub.stubResponse = URLSessionStub.ResponseStub.errorResponse(url: url, error: error)
        
        let completion: (LetterStub) -> Void = { _ in
            fatalError("Should not happen")
        }
        
        sut.post(request: enveloppe, completion: completion)
        syncQueue(queue)
        XCTAssertTrue(errorReceived!.underlyingError! as NSError == error)
    }
    
    func test_whenInput_emptyData() {
        let url = URL.stub
        let enveloppe = EnveloppeStub(path: url.absoluteString, url: url)
        sessionStub.stubResponse = URLSessionStub.ResponseStub.noDataResponse(url: url)
        
        let completion: (LetterStub) -> Void = { _ in
            fatalError("Should not happen")
        }
        
        sut.post(request: enveloppe, completion: completion)
        syncQueue(queue)
        XCTAssertTrue(errorReceived! === EnveloppeError.emptyData)
    }
    
    func test_whenInput_notHTTPRequest() {
        let url = URL.stub
        let enveloppe = EnveloppeStub(path: url.absoluteString, url: url)
        sessionStub.stubResponse = URLSessionStub.ResponseStub.notHTTPResponse(url: url)
        
        let completion: (LetterStub) -> Void = { _ in
            fatalError("Should not happen")
        }
        
        sut.post(request: enveloppe, completion: completion)
        syncQueue(queue)
        XCTAssertTrue(errorReceived! === EnveloppeError.notHTTP)
    }
    
    func test_whenInput_invalidStatusCode() {
        let url = URL.stub
        let enveloppe = EnveloppeStub(path: url.absoluteString, url: url)
        sessionStub.stubResponse = URLSessionStub.ResponseStub.invalidStatusCode(url: url, code: 300)
        
        let completion: (LetterStub) -> Void = { _ in
            fatalError("Should not happen")
        }
        
        sut.post(request: enveloppe, completion: completion)
        syncQueue(queue)
        XCTAssertTrue(errorReceived.statusCode! == 300)
    }
}


// MARK: - Stubs, Mocks, Spies
class EnveloppeSerializerMock: EnveloppeSerializable {
    var data: Data!
    func buildJSON(method: EnveloppeMethod, url: URL, data: Data) -> URLRequest {
        self.data = data
        return URLRequest(url: url)
    }
}

struct EnveloppeStub: Envelopable {
    typealias LetterType = LetterStub
    
    //url representable
    var path: String
    var url: URL
    
    func fetch(completion: @escaping (LetterType) -> Void) {
        Enveloppe().post(request: self, completion: completion)
    }
}


struct LetterStub: Decodable {
    let content: String
}
