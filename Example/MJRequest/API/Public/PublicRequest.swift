//
//  PublicRequest.swift
//  MJRequest_Example
//
//  Created by chenminjie on 2021/3/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import MJRequest
import Moya

public class PublicRequest: MJRequest  {
    
    public func requestWithModel<T: Codable>(model: T.Type, completion: @escaping ((_ result: MJResult<T?, MJResponseError>) -> Void)) {

        request(result: PublicResponseResult<T>.self) { (response) in
            switch response {
            case .success(let data):
                if data?.code == 200 {
                    completion(MJResult.init(value: data?.result))
                }else {
                    completion(MJResult.init(error: MJResponseError.business(data?.code ?? -200, data?.message ?? "未知")))
                }
            case .failure(let error):
                completion(MJResult.init(error: error))
            }
        }
    }
}
