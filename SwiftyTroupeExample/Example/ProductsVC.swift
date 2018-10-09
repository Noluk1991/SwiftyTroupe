//
//  ProductsVC.swift
//  SwiftyTroupeExample
//
//  Created by Andryuhin Aleksandr Gennadevich on 10/9/18.
//  Copyright © 2018 Andryuhin Aleksandr Gennadevich. All rights reserved.
//

import UIKit

class ProductsVC: UIViewController {

    @IBOutlet weak var productsTV: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var products = [Product]()

    private let productsActor = Troupe.default.createActor(name: "product") {
        return ProductActor()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        productsTV.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        productsTV.dataSource = self
        productsTV.isHidden = true

        activityIndicator.startAnimating()

        Troupe.default.notificationCenter.addObserver(self, selector: #selector(updateUI(_:)), name: productsActor.notificatioName, object: nil)

        productsActor.tell(ProductMessage.fetch)

    }

    @objc func updateUI(_ notification: Notification) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        productsTV.isHidden = false


        let result = notification.userInfo?[productsActor.notificatioName] as? ProductMessage
        if case .success(let products)? = result {
            self.products = products
        }

        productsTV.reloadData()
    }

}

extension ProductsVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTV.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = products[indexPath.row].tile
        return cell
    }
}
