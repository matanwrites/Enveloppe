//
//  EnveloppeSerializer.swift
//  Enveloppe
//
//  Created by Mathieu Tan on 2018/9/21.
//  Copyright © 2018 Mathieu Tan. All rights reserved.
//

import Foundation


class EnveloppeSerializer: EnveloppeSerializable {
    func buildJSON(method: EnveloppeMethod, url: URL, data: Data) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
