//
//  OCRClient.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/6.
//

import Foundation
import Moya
import RxSwift

class OCRClient: BaseClient {
    static let manager = OCRClient.init()
    var ocrPovider = MoyaProvider<OCRAPI>.init()
    var queue = DispatchQueue.init(label: "OCRClientQueue", qos: .default, attributes: .concurrent)
    func ocrByBase64(dataBase64: String) -> Observable<Response> {
        if !isNetworkConnect {
            return Observable.error(NetWorkError.noneNetWork)
        }
        
        return ocrPovider.rx.request(.OCRByBase64(dataBase64: dataBase64), callbackQueue: queue).asObservable()
    }
}
