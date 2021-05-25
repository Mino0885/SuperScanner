//
//  API.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/6.
//

import Foundation
import Moya
import SwiftyJSON

public enum OCRAPI {
    case OCRByBase64(dataBase64: String)
    case OCRByUrl(Url: String)
}


extension OCRAPI: TargetType {
    public var baseURL: URL {
        return URL.init(string: "https://ocrapi-advanced.taobao.com")!
    }
    
    public var path: String {
        switch self {
        case .OCRByBase64:
            return "/ocrservice/advanced"
        case .OCRByUrl:
            return "/ocrservice/advanced"
        default:
            break
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .OCRByBase64:
            return .post
        case .OCRByUrl:
            return .post
        default:
            break
        }
    }
    
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    public var task: Task {
        sLog.verbose("will load request \(self) method: \(self.method.rawValue)")
        switch self {
        case let .OCRByBase64(dataBase64):
            //            var body = "{\"img\":\"\",\"url\":\"\",\"prob\":false,\"charInfo\":false,\"rotate\":false,\"table\":false}"
            var pram: [String : Any] = ["img": dataBase64, "prob": true, "charInfo": true, "rotate": true, "table": true, "sortPage": false]
            var json = JSON(pram)
            return .requestData(try! json.rawData())
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Authorization": "APPCODE \(OCRConfig.appCode)",
            "Content-Type": "application/json; charset=UTF-8"
        ]
    }
    
    
}
