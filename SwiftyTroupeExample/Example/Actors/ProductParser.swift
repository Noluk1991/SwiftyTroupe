//
//  ProductParser.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

class ProductParser: BaseActor {

    private enum Addresses: String {
        case product
        case storage
    }

    override func receive(_ message: Any) {
        guard let productMessage = message as? ParserMessage else {
            return super.receive(message)
        }
        switch productMessage {
        case .product(_):
            // data -> json -> [Product]
            // ...
            let result = [Product()]
            let loginActor = context.createActor(name: Addresses.product.rawValue)
            loginActor.tell(ProductMessage.success(result))

            let storage = context.createActor(name: Addresses.storage.rawValue)
            storage.tell(StorageMessage.saveProducts(result))


        case .user(_): super.receive(productMessage)
        }

    }
}
