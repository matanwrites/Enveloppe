//
//  XCTestCase.swift
//  Tests
//
//  Created by Mathieu Tan on 2018/9/21.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import XCTest


extension XCTestCase {
    func syncQueue(_ queue: DispatchQueue) {
        for _ in 0..<5 {
            queue.sync {}
        }
    }
}
