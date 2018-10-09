//
//  StorageActor.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

enum StorageMessage {
    case saveUser(User)
    case saveProducts([Product])
}

class StorageActor: BaseActor {

    override func receive(_ message: Any) {
        guard let storageMessage = message as? StorageMessage else {
            return super.receive(message)
        }
        switch storageMessage {
        case .saveUser(_): break
            // save user
        case .saveProducts(_): break
            // save products
        }
    }
}
