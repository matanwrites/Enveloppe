//
//  EnveloppeErrorObserverTests.swift
//  Tests
//
//  Created by sintaiyuan on 9/24/18.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import XCTest
import Enveloppe


class EnveloppeErrorObserverTests: XCTestCase {
    var sut: EnveloppeErrorObserver!
    var obsToken: NSObjectProtocol!


    override func setUp() {
        super.setUp()
        sut = EnveloppeErrorObserver.instance
    }

    override func tearDown() {
        super.tearDown()
        sut.flush()
    }
}


// MARK: - ProduceError
extension EnveloppeErrorObserverTests {
    func test_produceError_enqueues_error() {
        let e = EnveloppeError.emptyData

        sut.produceError(e)

        XCTAssertTrue(sut.errors.last! === e)
    }

    func test_produceError_notify() {
        let e = EnveloppeError.emptyData

        obsToken = NotificationCenter.default.addObserver(forName: EnveloppeErrorObserver.errorReceived,
                                                          object: EnveloppeErrorObserver.instance,
                                                          queue: nil) { _ in

            let consumedError = self.sut.consumeNextError()!
            XCTAssertTrue(e === consumedError)
            NotificationCenter.default.removeObserver(self.obsToken)
        }

        sut.produceError(e)
    }
}


// MARK: - ConsumeNextError
extension EnveloppeErrorObserverTests {
    func test_ifHasError_consumeNextError_consume_queue() {
        let e = EnveloppeError.emptyData
        sut.onError(e)

        let consumedError = sut.consumeNextError()!
        XCTAssertTrue(e === consumedError)
        XCTAssertTrue(sut.errors.isEmpty)

    }

    func test_ifNoError_consumeNextError_returns_nil() {
        XCTAssertTrue(sut.consumeNextError() == nil)
    }
}
