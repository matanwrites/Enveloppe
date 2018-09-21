//
//  EnveloppeSerializerTests.swift
//  Tests
//
//  Created by Mathieu Tan on 2018/9/21.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import XCTest
@testable import Enveloppe


class EnveloppeSerializerTests: XCTestCase {
    func test_buildJSON_url() {
        let url = URL.stub
        let data = try! JSONSerialization.data(withJSONObject: ["k":"v"], options: .prettyPrinted)
        let r = EnveloppeSerializer().buildJSON(method: .POST, url: url, data: data)
        
        XCTAssertEqual(r.url!, url)
        XCTAssertEqual(r.httpBody, data)
        XCTAssertEqual(r.httpMethod!, "POST")
        XCTAssertEqual(r.allHTTPHeaderFields!["Content-Type"], "application/json")
        XCTAssertEqual(r.allHTTPHeaderFields!["Accept"], "application/json")
    }
}
