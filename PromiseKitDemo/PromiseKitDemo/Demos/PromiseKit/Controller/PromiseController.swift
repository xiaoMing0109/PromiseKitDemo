//
//  PromiseController.swift
//  PromiseKitDemo
//
//  Created by 怦然心动-LM on 2022/11/23.
//

import UIKit
import PromiseKit
import SnapKit

class PromiseController: BaseViewController {

// MARK: Public Property
    
    
// MARK: Private Property
    private lazy var viewModel = PromiseViewModel()
    
// MARK: ============== Life Cycle ==============
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        makeConstraints()
        netRequest()
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
    
    deinit {}
    
// MARK: Setup Subviews
    private func setupSubviews() {
        view.addSubview(stackView)
        view.addSubview(loadingView)
    }
    
    private lazy var stackView: UIStackView = {
        func generateButton(withTitle title: String) -> UIButton {
            let button = UIButton(type: .custom)
            button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(onClickedButtonAction(_:)), for: .touchUpInside)
            return button
        }
        
        traditionalCallbackHellButton = generateButton(withTitle: "Traditional Callback Hell")
        traditionalQueueButton = generateButton(withTitle: "Traditional Queue")
        promiseSyncButton = generateButton(withTitle: "Promise Sync")
        promiseWhenButton = generateButton(withTitle: "Promise when")
        promiseRaceButton = generateButton(withTitle: "Promise race")
        promiseOtherSamplesButton = generateButton(withTitle: "Promise other Samples")
        
        let view = UIStackView(
            arrangedSubviews: [traditionalCallbackHellButton,
                               traditionalQueueButton,
                               promiseSyncButton,
                               promiseWhenButton,
                               promiseRaceButton,
                               promiseOtherSamplesButton]
        )
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 20
        return view
    }()
    
    private var traditionalCallbackHellButton: UIButton!
    private var traditionalQueueButton: UIButton!
    private var promiseSyncButton: UIButton!
    private var promiseWhenButton: UIButton!
    private var promiseRaceButton: UIButton!
    private var promiseOtherSamplesButton: UIButton!
    
// MARK: Make Constraints
    private func makeConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: ============== Private ==============
extension PromiseController {}

// MARK: ============== Public ==============
extension PromiseController {}

// MARK: ============== Network ==============
extension PromiseController {
    
    private func netRequest() {}
    
    // MARK: 传统方式实现网络请求
    
    /// 连续回调方式
    private func traditionalRequestWithCallbackHellStyle() {
        viewModel.requestTokenTraditionalStyle { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                print("token: \(token)")
                
                self.viewModel.requestUserTraditionalStyle(token: token) { result in
                    switch result {
                    case .success(let user):
                        print("user: \(user)")
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Queue + Semaphore 方式
    private func traditionalRequestWithQueueStyle() {
        let serialQueue = DispatchQueue(label: "com.test.request.serialQueue")
        let semaphore = DispatchSemaphore(value: 1)
        
        var requestToken: String = ""// request 2 参数
        serialQueue.async {
            semaphore.wait()
            
            self.viewModel.requestTokenTraditionalStyle { result in
                defer { semaphore.signal() }
                
                switch result {
                case .success(let token):
                    print("token: \(token)")
                    requestToken = token
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        serialQueue.async {
            semaphore.wait()
            
            self.viewModel.requestUserTraditionalStyle(token: requestToken) { result in
                defer { semaphore.signal() }
                
                switch result {
                case .success(let user):
                    print("user: \(user)")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: Promise 实现网络请求方式
    
    private func promiseRequestStyle() {
        loadingView.startAnimating()
        
        viewModel.requestTokenPromiseStyle()
            .then { [weak self] token -> Promise<PromiseModel.User> in
                print("token: \(token)")
                
                guard let self = self else {
                    return Promise(error: SelfError.canNotCaptureSelf)
                }
                return self.viewModel.requestUserPromiseStyle(token: token)
            }
            .done { user in
                print("user: \(user)")
            }
            .ensure { [weak self] in
                guard let self = self else { return }
                self.loadingView.stopAnimating()
                print("ensure!")
            }
            .catch { error in
                print(error)
            }
    }
    
    private func whenAllRequestFinished() {
        when(fulfilled: viewModel.requestTokenPromiseStyle(), viewModel.requestUserPromiseStyle(token: ""))
            .done { (token, user) in
                print("""
                token: \(token),
                user: \(user)
                """)
            }
            .ensure {
                print("所有任务均成功结束！")
            }
            .catch { error in
                print(error)
            }
    }
    
    /// - Note: 返回类型需为一致(Promise<T>)
    /// - 触发第一个回调为成功, 即为成功
    /// - 触发第一个回调为失败, 即为失败
    private func raceAnyRequestFinished() {
        race(fulfilled: [viewModel.requestTokenPromiseStyle(),
                         viewModel.requestTokenPromiseStyle()])
            .done { token in
                print(token)
            }
            .catch { error in
                print(error)
            }
    }
    
    // MARK: Other Promise Samples
    
    func haveLunch() {
        viewModel.cook()
            .then { [weak self] _ -> Promise<Void> in
                guard let self = self else {
                    return Promise(error: SelfError.canNotCaptureSelf)
                }
                return self.viewModel.eat()
            }
            .then { [weak self] _ -> Promise<Void> in
                guard let self = self else {
                    return Promise(error: SelfError.canNotCaptureSelf)
                }
                return self.viewModel.wash()
            }
            .done { _ in
                print("done!")
            }
            .ensure {
                print("ensure!")
            }
            .catch { error in
                print(error)
            }
    }
}

// MARK: ============== Action ==============
extension PromiseController {
    
    @objc private func onClickedButtonAction(_ sender: UIButton) {
        switch sender {
        case traditionalCallbackHellButton:
            traditionalRequestWithCallbackHellStyle()
        case traditionalQueueButton:
            traditionalRequestWithQueueStyle()
        case promiseSyncButton:
            promiseRequestStyle()
        case promiseWhenButton:
            whenAllRequestFinished()
        case promiseRaceButton:
            raceAnyRequestFinished()
        case promiseOtherSamplesButton:
            haveLunch()
        default: break
        }
    }
}

// MARK: ============== Delegate ==============
extension PromiseController {}

// MARK: ============== Observer ==============
extension PromiseController {}

// MARK: ============== Notification ==============
extension PromiseController {}
