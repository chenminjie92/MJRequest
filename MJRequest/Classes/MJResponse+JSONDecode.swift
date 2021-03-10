//
//  MJResponse+JSONDecode.swift
//  MJRequest
//
//  Created by chenminjie on 2021/3/10.
//

import Foundation
import Moya

extension Moya.Response {

    /// 使用JSONDecoder把JSON序列化成Model
    ///
    /// - Parameter type: 自定义Model的Type
    /// - Returns: 实例化的Model
    /// - Throws: 序列化错误
    public func decodeJSON<T>(from type: T.Type) throws -> T where T: Codable {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw MJResponseError.decode(3840, error.localizedDescription)
        }
    }
}
