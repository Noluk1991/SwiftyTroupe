//
//  ResultCollector.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

enum ResultCollectorMessage {
    case collect(Any)
    case giveAway([Any])
}

class ResultCollector: BaseActor {

    private let capacity: Int
    private var storage = [Any]()

    init(capacity: Int) {
        self.capacity = capacity
        super.init()
    }

    override func receive(_ message: Any) {
        guard let resultMessage = message as? ResultCollectorMessage else {
            return super.receive(message)
        }
        if case .collect(let result) = resultMessage {
            storage.append(result)
        }
        if storage.count == capacity {
            context.post(message: ResultCollectorMessage.giveAway(storage), from: self)
            storage.removeAll()
        }
    }
}
