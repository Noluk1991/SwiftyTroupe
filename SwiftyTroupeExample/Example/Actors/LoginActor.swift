//
//  LoginActor.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

enum LoginActorMessage {
    case login
    case success(User)
    case failure(String)
}

class LoginActor: BaseActor {

    private enum Addresses: String {
        case network
    }

    override func receive(_ message: Any) {
        guard let loginMessage = message as? LoginActorMessage else {
            return super.receive(message)
        }

        switch loginMessage {
        case .login:
            let networkActor = context.createActor(name: Addresses.network.rawValue) {
                return NetworkActor()
            }
            networkActor.tell(NetworkActorMessage.login)
        case .success(_), .failure(_):
             context.post(message: loginMessage, from: self)
        }
    }
}
