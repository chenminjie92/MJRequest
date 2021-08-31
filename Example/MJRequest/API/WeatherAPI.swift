//
//  WeatherAPI.swift
//  MJRequest_Example
//
//  Created by chenminjie on 2021/3/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import MJRequest

struct WeatherAPI {
    
    /// 获取段子
    /// - Parameters:
    ///   - page: 页码
    ///   - count: 数量
    ///   - type: 类型
    ///   - completion: 回调
    static func getJoke(for page: Int, count: Int, type: String, completion: @escaping ((_ result: MJResult<[JokeVO]?, MJResponseError>) -> Void)) {

        let path = "/getJoke"
        var parameters: [String: Any] = [:]
        parameters["page"] = page
        parameters["type"] = type
        parameters["count"] = count
        let req = PublicRequest(method: .get, url: .baseUrl(host: "api.apiopen.top", path: path), parameters: parameters)
        req.requestWithModel(model: [JokeVO].self, completion: completion)
    }
}
