//
//  PromiseModel.swift
//  PromiseKitDemo
//
//  Created by 怦然心动-LM on 2022/11/23.
//

import UIKit

struct PromiseModel {
    struct Token: Decodable {
        var token: String?
    }
    
    struct User: Decodable {
        var name: String?
        var gender: String?
    }
}
