//
//  OCRModel.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/6.
//

import Foundation
import RxSwift

class OCRModel: BaseModel {
    private override init() {
        super.init()
    }
    static let `default` = OCRModel.init()
    
    func ocrByBase64(dataBase64: String) {
        OCRClient.manager.ocrByBase64(dataBase64: dataBase64).mapString().subscribe { str in
            sLog.debug("\(str)")
        } onError: { error in
            if let e = error as? NetWorkError {
                sLog.error("\(e.debugDescription)")
            }
        } onCompleted: {
            sLog.verbose("is onCompleted ")
        } onDisposed: {
            sLog.verbose("is onDisposed ")
        }

    }
}
