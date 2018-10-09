//
//  ErrorsActor.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

enum ErrorHandlerMessage {
    case networkError(Error?)
}

class ErrorsActor: BaseActor {

    override func receive(_ message: Any) {
        guard let _ = message as? ErrorHandlerMessage else {
            return super.receive(message)
        }
        // handle message
    }

}
