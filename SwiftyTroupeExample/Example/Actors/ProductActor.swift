//
//  ProductActor.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

enum ProductMessage {
    case fetch
    case success([Product])
    case failure(String)
}

class ProductActor: BaseActor {

    private enum Addresses: String {
        case network
    }

    override func receive(_ message: Any) {
        guard let productMessage = message as? ProductMessage else {
            return super.receive(message)
        }

        switch productMessage {
        case .fetch:
            let networkActor = context.createActor(name: Addresses.network.rawValue)
            networkActor.tell(NetworkActorMessage.productList)

        case .success(_), .failure(_):
            context.post(message: productMessage, from: self)
        }
    }
}
