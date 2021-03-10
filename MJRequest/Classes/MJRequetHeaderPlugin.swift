//
//  MJRequetHeaderPlugin.swift
//  MJRequest
//
//  Created by chenminjie on 2021/3/10.
//

import Foundation
import Moya

public struct MJRequetHeaderPlugin: PluginType {

    public typealias HerderClosure = () -> [String: String]

    
    private let headerClosure: HerderClosure

    
    public init(headerClosure: @escaping HerderClosure) {
        self.headerClosure = headerClosure
    }

    /// 发送请求前做一些修改
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

        var request = request
        let authValue = headerClosure()
        for _item in authValue {
            request.addValue(_item.value, forHTTPHeaderField: _item.key)
        }
        return request
    }
}
