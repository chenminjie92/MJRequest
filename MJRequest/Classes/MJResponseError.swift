//
//  MJResponseError.swift
//  MJRequest
//
//  Created by chenminjie on 2021/3/10.
//

import Foundation

public enum MJResponseError: Swift.Error {
    ///httpcode 和 错误信息
    case http(Int, String?)
    ///解码错误
    case decode(Int, String?)
    ///业务code 和 错误信息
    case business(Int, String?)
    
    public var msg: String {
        switch self {
        case .http(_, let message):
            return message ?? ""
        case .decode(_, let message):
            return message ?? ""
        case .business(_, let message):
            return message ?? ""
        }
    }
    
    public var code: Int {
        switch self {
        case .http(let code, _):
            return code
        case .decode(let code, _):
            return code
        case .business(let code, _):
            return code
        }
    }
}
