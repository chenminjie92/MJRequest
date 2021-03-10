//
//  MJRequest.swift
//  Alamofire
//
//  Created by chenminjie on 2021/3/10.
//

import Foundation
import Moya

open class MJRequest: NSObject {
    
    public enum Encoding {
        /// 多数情况使用该枚举
        /// 对 `GET`, `HEAD` and `DELETE` 的query stirng encode，其他HTTPMethod 对HTTPBody encode
        /// POST情况下 Content-Type=`application/x-www-form-urlencoded; charset=utf-8`
        case urlEncoding
        /// post请求，在body需要序列化json的时候， 使用该枚举
        /// Content-Type=`application/json`
        case jsonEncoding
    }
    
    private var privatePath: String = ""
    private var privateHost: String = ""
    private var privateMethod: Moya.Method = .post
    private var privateHeaders: [String: String]?
    private var privateEncoding: Encoding = .urlEncoding
    private var privateParameters: [String: Any]?
    private var privateFormData: [MJUploadFile]?
    
    
    private lazy var provider = {
        return MoyaProvider<MJRequest>(plugins: MJRequestManager.plugins)
    }()
    
    /// 资源上传
    /// - Parameters:
    ///   - host: host
    ///   - path: 路径
    ///   - formData: 资源
    ///   - parameters: 参数
    ///   - header: 头部
    public init(host: String, path: String, formData: [MJUploadFile], parameters: [String: Any]?,header: [String: String]? = MJRequestManager.config?.normalHeader) {
        privateHost = host
        privatePath = path
        privateFormData = formData
        privateParameters = parameters
        privateHeaders = header
        super.init()
    }
    
    /// 普通请求
    /// - Parameters:
    ///   - method: 请求方式
    ///   - host: host
    ///   - path: 路径
    ///   - parameters: 参数
    ///   - header: 头部
    ///   - encoding: 编码方式
    public init(method: Moya.Method = .post, host: String, path: String, parameters: [String: Any]?, header: [String: String]? = nil, encoding: Encoding = .urlEncoding) {
        privateMethod = method
        privateHost = host
        privatePath = path
        privateParameters = parameters
        privateHeaders = header
        if encoding == .jsonEncoding {
            if privateHeaders == nil {
                privateHeaders = [:]
            }
            privateHeaders?["Content-type"] = "application/json"
        }
        privateEncoding = encoding
    }
    
    
    /// 开始请求
    /// - Parameters:
    ///   - result: 结果数据类型
    ///   - completion: 结果
    public func request<T: Codable>(result: T.Type, completion:@escaping ((_ result: MJResult<T?, MJResponseError>) -> Void)) {
        
        provider.request(self, callbackQueue: nil, progress: nil) { (_result) in
            switch _result {
            case let .success(response):

                do {
                    let model = try response.decodeJSON(from: result.self)
                    completion(MJResult.init(value: model))
                } catch let error {
                    completion(MJResult.init(error: error as! MJResponseError))
                }
            case let .failure(error):
                completion(MJResult.init(error: MJResponseError.http(error.errorCode, error.errorDescription ?? "未知")))
            }
        }
    }
    
}

extension MJRequest: TargetType {
    
    /// 单元测试
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    /// 接口域名
    public var baseURL: URL {
        return URL(string:  "\(MJRequestManager.config?.agreement ?? "https")://\(privateHost)\(MJRequestManager.config?.domainDot ?? "")")!
    }
    
    /// 请求路径
    public var path: String {
        return privatePath
    }
    
    /// 请求方式
    public var method: Moya.Method {
        return privateMethod
    }
    
    //header信息
    public var headers: [String: String]? {
        return privateHeaders
    }
    
    /// 超时时间
    public var timeoutInterval: Int {
        return 15
    }
    
    /// 请求任务
    public var task: Task {
        /// 资源上传
        if let files = privateFormData, files.count > 0 {
            var datas: [MultipartFormData] = []
            for file in files {
                switch file {
                case let .image(data, paramName, fileName, mimeType):
                    let _data = MultipartFormData(provider: .data(data), name: paramName, fileName: fileName, mimeType: mimeType)
                    datas.append(_data)
                case let .media(url, paramName, fileName):
                    if let data = try? MultipartFormData(provider: .data(Data(contentsOf: url)), name: paramName, fileName: fileName, mimeType: "audio/mpeg") {
                        datas.append(data)
                    }
                }
            }
            if let parameters = privateParameters {
                return .uploadCompositeMultipart(datas, urlParameters: parameters)
            }
            return .uploadMultipart(datas)
        }
        guard let parameters = privateParameters else {
            return .requestPlain
        }
        if method == .get {
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        } else {
            if privateEncoding == .jsonEncoding {
                if let jsonData = jsonToData(jsonDic: parameters) {
                    return .requestData(jsonData)
                }
                else {
                    return .requestPlain
                }
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
        }
    }
    
    
    private func jsonToData(jsonDic: [String: Any]) -> Data? {
        if (!JSONSerialization.isValidJSONObject(jsonDic)) {
            debugPrint("is not a valid json object")
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        return data
    }
}
