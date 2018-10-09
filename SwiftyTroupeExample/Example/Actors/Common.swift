//
//  Common.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

enum ParserMessage {
    case user(Data?)
    case product(Data?)
}

struct User {}

struct Product {
    let tile = "Product From Actors"
}

extension URLSession {

    func synchronousRequest(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
            semaphore.signal()
        }.resume()

        semaphore.wait()
    }
}
