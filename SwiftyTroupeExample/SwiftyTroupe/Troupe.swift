//
//  Troupe.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import Foundation

class Troupe {

    static let `default` = Troupe()

    let notificationCenter = NotificationCenter()

    private let lock = NSRecursiveLock()
    private var refs: [String: ActorRef] = [String: ActorRef]()

    private init() {}

    // TODO: Name -> ?

    func createActor(name: String, creator: (() -> BaseActor)? = nil) -> ActorRef {
        defer { lock.unlock() }
        lock.lock()
        if let ref = refs[name] {
            return ref
        } else {
            let actor = creator?() ?? BaseActor()
            let ref = ActorRef(actor: actor, address: name, context: self)
            refs[name] = ref
            return ref
        }
    }

    // TODO: NotificationCenter -> View bindings

    func post<Message: Any>(message: Message, from sender: BaseActor, onMainThread: Bool = true) {
        let notification = Notification(name: sender.notificationName, object: nil, userInfo: [sender.notificationName: message])
        if onMainThread {
            DispatchQueue.main.async {
                self.notificationCenter.post(notification)
            }
        } else {
            notificationCenter.post(notification)
        }
    }

}
