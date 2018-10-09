//
//  LoginVC.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    private let loginActor = Troupe.default.createActor(name: "login") {
        return LoginActor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Troupe.default.notificationCenter.addObserver(self, selector: #selector(updateUI(_:)), name: loginActor.notificatioName, object: nil)
        
    }

    @objc func updateUI(_ notification: Notification) {
        performSegue(withIdentifier: "ProductVCIdentifier", sender: self)
    }

    @IBAction func login(_ sender: UIButton) {
        loginActor.tell(LoginActorMessage.login)
    }
}
