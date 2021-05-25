//
//  NetWorkError.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/6.
//

import Foundation
import Alamofire

public enum NetWorkError: Error {
    case error404
    case otherError(description: String)
    case swapError
    case noneCode
    case noneNetWork
}

extension NetWorkError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .error404:
            return "服务器异常-404"
        case .swapError:
            return "服务器异常-701"
        case .noneCode:
            return "服务器异常-702"
        case .noneNetWork:
            return "暂无网络"
        case .otherError(let description):
            return description
        default:
            return ""
        }
    }
    
    
}
