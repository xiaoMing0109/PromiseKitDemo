//
//  PromiseViewModel.swift
//  PromiseKitDemo
//
//  Created by 怦然心动-LM on 2022/11/23.
//

import UIKit
import PromiseKit

class PromiseViewModel {
    enum MealError: Error, CustomStringConvertible {
        case burnt
        
        var description: String {
            switch self {
            case .burnt:
                return "饭糊了"
            }
        }
    }
    
// MARK: Public Property
    
    
// MARK: Private Property
    
    
// MARK: ============== Life Cycle ==============
    init() {}
    
    deinit {}
}

// MARK: ============== Private ==============
extension PromiseViewModel {}

// MARK: ============== Public ==============
extension PromiseViewModel {
    
    // MARK: 传统方式实现网络请求
    
    func requestTokenTraditionalStyle(completion: @escaping (Result<String>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:3000/token")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200 ... 299).contains(statusCode)
            else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tokenModel = try decoder.decode(PromiseModel.Token.self, from: data ?? Data())
                DispatchQueue.main.async {
                    completion(.success(tokenModel.token ?? ""))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func requestUserTraditionalStyle(token: String, completion: @escaping (Result<PromiseModel.User>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:3000/user?token=\(token)")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200 ... 299).contains(statusCode)
            else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userModel = try decoder.decode(PromiseModel.User.self, from: data ?? Data())
                DispatchQueue.main.async {
                    completion(.success(userModel))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: Promise 实现网络请求
    
    func requestTokenPromiseStyle() -> Promise<String> {
        var request = URLRequest(url: URL(string: "http://localhost:3000/token")!)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTask(.promise, with: request)
            .validate()
            .compactMap { data, _ in
                let decoder = JSONDecoder()
                let tokenModel = try decoder.decode(PromiseModel.Token.self, from: data)
                return tokenModel.token ?? ""
            }
    }
    
    func requestUserPromiseStyle(token: String) -> Promise<PromiseModel.User> {
        var request = URLRequest(url: URL(string: "http://localhost:3000/user?token=\(token)")!)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTask(.promise, with: request)
            .validate()
            .compactMap { data, _ in
                let decoder = JSONDecoder()
                let userModel = try decoder.decode(PromiseModel.User.self, from: data)
                return userModel
            }
    }
    
    // MARK: Promise Other Examples
    
    func cook() -> Promise<Void> {
        return Promise<Void> { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    print("饭做好了.")
                    seal.fulfill_()
                }
            }
        }
    }
    
    func eat() -> Promise<Void> {
        return Promise<Void> { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    print("吃饱了.")
                    seal.fulfill_()
                }
            }
        }
    }
    
    func wash() -> Promise<Void> {
        return Promise<Void> { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    print("碗洗干净了.")
                    seal.fulfill_()
                }
            }
        }
    }
}

// MARK: ============== Network ==============
extension PromiseViewModel {}

// MARK: ============== Delegate ==============
extension PromiseViewModel {}

// MARK: ============== Observer ==============
extension PromiseViewModel {}

// MARK: ============== Notification ==============
extension PromiseViewModel {}
