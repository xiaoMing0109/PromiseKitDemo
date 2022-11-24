//
//  RXSwiftViewModel.swift
//  PromiseKitDemo
//
//  Created by 怦然心动-LM on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa

class RXSwiftViewModel {
    
// MARK: Public Property
    
    
// MARK: Private Property
    
    
// MARK: ============== Life Cycle ==============
    init() {}
    
    deinit {}
}

// MARK: ============== Private ==============
extension RXSwiftViewModel {}

// MARK: ============== Public ==============
extension RXSwiftViewModel {}

// MARK: ============== Network ==============
extension RXSwiftViewModel {
    
    // MARK: RxSwift 实现网络请求
    
    func requestTokenRxSwiftStyle() -> Observable<String> {
        var request = URLRequest(url: URL(string: "http://localhost:3000/token")!)
        request.httpMethod = "GET"
        
        return URLSession.shared.rx.data(request: request)
            .compactMap { data in
                let decoder = JSONDecoder()
                let tokenModel = try decoder.decode(PromiseModel.Token.self, from: data)
                return tokenModel.token ?? ""
            }
            .observe(on: MainScheduler.instance)
    }
    
    func requestUserRxSwiftStyle(token: String) -> Observable<PromiseModel.User> {
        var request = URLRequest(url: URL(string: "http://localhost:3000/user?token=\(token)")!)
        request.httpMethod = "GET"
        
        return URLSession.shared.rx.data(request: request)
            .compactMap { data in
                let decoder = JSONDecoder()
                let userModel = try decoder.decode(PromiseModel.User.self, from: data)
                return userModel
            }
            .observe(on: MainScheduler.instance)
    }
    
    // MARK: Promise Other Examples
    
    func cook() -> Observable<Void> {
        return Observable<Void>.create { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    print("饭做好了.")
                    seal.onNext(())
                }
            }
            return Disposables.create()
        }
    }
    
    func eat() -> Observable<Void> {
        return Observable<Void>.create { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    print("吃饱了.")
                    seal.onNext(())
                }
            }
            return Disposables.create()
        }
    }
    
    func wash() -> Observable<Void> {
        return Observable<Void>.create { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    print("碗洗干净了.")
                    seal.onNext(())
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: ============== Delegate ==============
extension RXSwiftViewModel {}

// MARK: ============== Observer ==============
extension RXSwiftViewModel {}

// MARK: ============== Notification ==============
extension RXSwiftViewModel {}
