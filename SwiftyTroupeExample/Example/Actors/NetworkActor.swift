//
//  NetworkActor.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

enum NetworkActorMessage {
    case login
    case productList
    case loginResult(Data)
    case loginFailure(Error?)
    case productListResult(Data)
    case productListFailure(Error?)
}

class NetworkActor: BaseActor {

    static let address = "network"

    private enum Addresses: String {
        case network
        case userParser = "UserParserActorName"
        case productParser = "ProductParserName"
        case errorHandler = "ErrorHandlerActorName"
    }

    private let networkQueue = DispatchQueue(label: "NetworkRequestQueue")

    private var errorsActor: ActorRef {
        return Troupe.default.createActor(name: Addresses.errorHandler.rawValue) {
            return ErrorsActor()
        }
    }

    override func receive(_ message: Any) {
        guard let networkMessage = message as? NetworkActorMessage else {
            return super.receive(message)
        }
        switch networkMessage {
        case .login:
            networkQueue.async { [weak self] in
                self?.performLogin()
            }
        case .productList:
            networkQueue.async { [weak self] in
                self?.fetchProductList()
            }

        case .loginResult(let data):
            let userParser = Troupe.default.createActor(name: Addresses.userParser.rawValue) {
                return UserParser()
            }
            let parserMessage = ParserMessage.user(data)
            userParser.tell(parserMessage)

        case .loginFailure(let error):
            let errorMessage = ErrorHandlerMessage.networkError(error)
            errorsActor.tell(errorMessage)

        case .productListResult(let data):
            let productParser = Troupe.default.createActor(name: Addresses.productParser.rawValue) {
                return ProductParser()
            }
            let parserMessage = ParserMessage.product(data)
            productParser.tell(parserMessage)

        case .productListFailure(let error):
            let errorMessage = ErrorHandlerMessage.networkError(error)
            errorsActor.tell(errorMessage)
        }
    }

    private func performLogin() {
        let loginUrl = URL(string: "https://jsonplaceholder.typicode.com/posts/42")!

        URLSession.shared.synchronousRequest(url: loginUrl) { (data, response, error) in
            var resultMessage: NetworkActorMessage
            if let data = data {
                resultMessage = NetworkActorMessage.loginResult(data)
            } else {
                resultMessage = NetworkActorMessage.loginFailure(error)
            }
            let networkActor = Troupe.default.createActor(name: Addresses.network.rawValue)
            networkActor.tell(resultMessage)
        }
    }

    private func fetchProductList() {
        let productsUrl = URL(string: "https://jsonplaceholder.typicode.com/posts/42")!
        sleep(5)
        URLSession.shared.synchronousRequest(url: productsUrl) { (data, response, error) in
            var resultMessage: NetworkActorMessage
            if let data = data {
                resultMessage = NetworkActorMessage.productListResult(data)
            } else {
                resultMessage = NetworkActorMessage.productListFailure(error)
            }
            let networkActor = Troupe.default.createActor(name: Addresses.network.rawValue)
            networkActor.tell(resultMessage)
        }
    }

    deinit {
        print("deinit of network actor")
    }

}
