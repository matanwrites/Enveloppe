//
//  EnveloppeFetchableTests.swift
//  Tests
//
//  Created by sintaiyuan on 9/24/18.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import XCTest
@testable import Enveloppe


class EnveloppeFetchableTests: XCTestCase {
    var sut: SomeRequest!

    override func setUp() {
        super.setUp()
        sut = SomeRequest(id: 8)
    }

    func test_fetch_delegates_to_defaultClient_defaultErrorObserver() {
        let client = EnveloppeSpy()
        let r = SomeRequest(id: 3)

        r.fetch(client: client) { _ in }

        XCTAssertTrue(client.errorDelegate! === EnveloppeErrorObserver.instance)
        XCTAssertTrue(client.didCallPost)
    }
}


// MARK: - Stubs
struct SomeRequest: Encodable {
    let id: Int
}

extension SomeRequest: EnveloppeFetchable {
    typealias LetterType = String

    var path: String { return "" }
    var url: URL { return .stub }
}


// MARK: - Spy
class EnveloppeSpy: Enveloppe {
    var didCallPost: Bool!
    override func post<E, D>(request: E, completion: @escaping (D) -> Void) where E: Enveloppable, D: Decodable {
        didCallPost = true
    }
}
