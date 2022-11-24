//
//  CustomError.swift
//  PromiseKitDemo
//
//  Created by 怦然心动-LM on 2022/11/23.
//

import Foundation

enum SelfError: Error {
    case canNotCaptureSelf
}

extension SelfError: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        switch self {
        case .canNotCaptureSelf:
            return "Can't capture self!"
        }
    }
    
    var debugDescription: String {
        return description
    }
}

struct NetworkError: Error {
    var code: Int
    var message: String?
    
    init(code: Int, message: String?) {
        self.code = code
        self.message = message
    }
}

extension NetworkError: CustomStringConvertible, CustomDebugStringConvertible {
    var localizedDescription: String {
        return """
        NetworkError:
            code: \(code),
            message: \(message ?? "nil")
        """
    }
    
    var description: String {
        return localizedDescription
    }
    
    var debugDescription: String {
        return localizedDescription
    }
}

enum Result<T> {
    case success(T)
    case failure(Error)
}
