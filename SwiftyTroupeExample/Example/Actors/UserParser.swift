//
//  UserParser.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

class UserParser: BaseActor {

    private enum Addresses: String {
        case login
        case storage
    }

    override func receive(_ message: Any) {
        guard let userMessage = message as? ParserMessage else {
            return super.receive(message)
        }
        switch userMessage {
        case .user(_):
            // data -> json -> User
            // ...
            let result = User()
            let loginActor = context.createActor(name: Addresses.login.rawValue)
            loginActor.tell(LoginActorMessage.success(result))

            let storage = context.createActor(name: Addresses.storage.rawValue) {
                return StorageActor()
            }
            storage.tell(StorageMessage.saveUser(result))

        case .product(_): super.receive(userMessage)
        }

    }
}
