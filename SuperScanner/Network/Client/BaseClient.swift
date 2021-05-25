//
//  BaseClient.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/6.
//

import Foundation
import Alamofire

class BaseClient {
    var isNetworkConnect: Bool {
        get{
            let network = NetworkReachabilityManager()
            return network?.isReachable ?? true //无返回就默认网络已连接
        }
    }
}
