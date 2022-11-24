//
//  ViewController.swift
//  PromiseKitDemo
//
//  Created by 怦然心动-LM on 2022/11/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    typealias Data = (text: String, vc: UIViewController.Type)
    private let dataSource: [Data] = [
        ("PromiseKit", PromiseController.self),
        ("RxSwift", RXSwiftController.self)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: Action
extension ViewController {
    
    private func route(with data: Data) {
        let vc = data.vc.init()
        vc.title = data.text
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = dataSource[indexPath.row]
        cell.textLabel?.text = data.text
        return cell
    }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = dataSource[indexPath.row]
        route(with: data)
    }
}
