//
//  PublicResponseResult.swift
//  MJRequest_Example
//
//  Created by chenminjie on 2021/3/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

public struct PublicResponseResult<T: Codable>: Codable {
    
    /// 状态码
    public var code: Int?
    /// 结果
    public var result: T?
    /// 错误文本
    public var message: String?

    public init(code: Int?, result: T?, message: String?) {
        self.code = code
        self.message = message
        self.result = result
    }
}
