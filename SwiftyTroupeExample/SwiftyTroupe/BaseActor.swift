//
//  BaseActor.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

class ActorRef {

    var notificatioName: Notification.Name {
        return actor.notificationName
    }

    private let actor: BaseActor

    init(actor: BaseActor, address: String, context: Troupe = .default) {
        let label = "\(address)-\(ObjectIdentifier(context).hashValue)"
        let mailbox = DispatchQueue(label: label)
        self.actor = actor
        self.actor.mailbox = mailbox
        self.actor.context = context
        self.actor.address = address
    }

    func tell<Message: Any>(_ message: Message) {
        actor.mailbox.async { [weak self] in
            self?.actor.receive(message)
        }
    }

}

class BaseActor {

    // TODO: NotificationName <-> Address

    fileprivate(set) var context: Troupe = .default

    fileprivate(set) var address: String = "Base Actor"

    var notificationName: Notification.Name {
        let name = mailbox == nil ? "\(ObjectIdentifier(self).hashValue)" : mailbox.label
        return Notification.Name(rawValue: name)
    }

    fileprivate var mailbox: DispatchQueue!

    init() {}

    open func receive(_ message: Any) {
        switch message {
        default:
            print("some unhandled message \(message) from \(address)")
        }
    }

}
