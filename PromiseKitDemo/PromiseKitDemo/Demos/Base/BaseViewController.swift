//
//  BaseViewController.swift
//  PromiseKitDemo
//
//  Created by 怦然心动-LM on 2022/11/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.color = .systemGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("✅✅✅ \(self) is \(#function)!")
    }
}
