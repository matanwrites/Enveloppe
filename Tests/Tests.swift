//
//  Tests.swift
//  Tests
//
//  Created by Mathieu Tan on 2018/9/18.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import XCTest
import Enveloppe

class Tests: XCTestCase {
    
    var subject: Enveloppe!

    override func setUp() {
        super.setUp()
        subject = Enveloppe()
    }
    
    func test_fetch() {
        let enveloppe = EnveloppeStub(path: "foo", url: URL(string: "bar")!)
        
        let completion: (String) -> Void = {
            print($0)
        }
        subject.post(request: enveloppe, completion: completion)
    }
}


struct EnveloppeStub: Envelopable {
    typealias LetterType = String
    
    var path: String
    var url: URL
    
    func fetch(completion: @escaping (String) -> Void) {
        let sender = Enveloppe()
        sender.extendURLRequest = {
            $0.setValue("foo", forHTTPHeaderField: "barfield")
        }
        sender.post(request: self, completion: completion)
    }
}
