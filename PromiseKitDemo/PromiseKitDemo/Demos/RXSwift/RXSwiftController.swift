//
//  RXSwiftController.swift
//  PromiseKitDemo
//
//  Created by 怦然心动-LM on 2022/11/23.
//

import UIKit
import RxSwift

class RXSwiftController: BaseViewController {
    
// MARK: Public Property
    
    
// MARK: Private Property
    private let disposeBag = DisposeBag()
    private lazy var viewModel = RXSwiftViewModel()
    
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
        
        rxSwiftSyncButton = generateButton(withTitle: "RxSwift Sync")
        rxSwiftOtherSamplesButton = generateButton(withTitle: "RxSwift other Samples")
        
        let view = UIStackView(
            arrangedSubviews: [rxSwiftSyncButton,
                               rxSwiftOtherSamplesButton]
        )
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 20
        return view
    }()
    
    private var rxSwiftSyncButton: UIButton!
    private var rxSwiftOtherSamplesButton: UIButton!
    
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
extension RXSwiftController {}

// MARK: ============== Public ==============
extension RXSwiftController {}

// MARK: ============== Network ==============
extension RXSwiftController {
    
    private func netRequest() {}
    
    // MARK: RxSwift 实现网络请求方式
    
    private func rxSwiftRequestStyle() {
        loadingView.startAnimating()
        
        viewModel.requestTokenRxSwiftStyle()
            .flatMapLatest { [weak self] token -> Observable<PromiseModel.User> in
                print("token: \(token)")
                
                guard let self = self else {
                    return Observable.error(SelfError.canNotCaptureSelf)
                }
                return self.viewModel.requestUserRxSwiftStyle(token: token)
            }
            .subscribe { [weak self] user in
                guard let self = self else { return }
                self.loadingView.stopAnimating()
                print("user: \(user)")
            } onError: { [weak self] error in
                guard let self = self else { return }
                self.loadingView.stopAnimating()
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: Other RxSwift Samples
    
    func haveLunch() {
        viewModel.cook()
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else {
                    return Observable.error(SelfError.canNotCaptureSelf)
                }
                return self.viewModel.eat()
            }
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else {
                    return Observable.error(SelfError.canNotCaptureSelf)
                }
                return self.viewModel.wash()
            }
            .subscribe { _ in
                print("finished.")
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: ============== Action ==============
extension RXSwiftController {
    
    @objc private func onClickedButtonAction(_ sender: UIButton) {
        switch sender {
        case rxSwiftSyncButton:
            rxSwiftRequestStyle()
        case rxSwiftOtherSamplesButton:
            haveLunch()
        default: break
        }
    }
}

// MARK: ============== Delegate ==============
extension RXSwiftController {}

// MARK: ============== Observer ==============
extension RXSwiftController {}

// MARK: ============== Notification ==============
extension RXSwiftController {}
