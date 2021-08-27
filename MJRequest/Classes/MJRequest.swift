//
//  MJRequest.swift
//  Alamofire
//
//  Created by chenminjie on 2021/3/10.
//

import Foundation
import Moya


open class MJRequest: NSObject {
    
    typealias ParameterEncoding = Moya.URLEncoding
    
    public enum RequestUrlEncoding {
        case queryString
        case httpBody
        case jsonEncoding
        
        var encoding: ParameterEncoding {
            switch self {
            case .queryString:
                return .queryString
            case .httpBody:
                return .httpBody
            case .jsonEncoding:
                return .httpBody
            }
        }
    }
    
    private var privatePath: String = ""
    private var privateHost: String = ""
    private var privateMethod: Moya.Method = .post
    private var privateHeaders: [String: String]? = MJRequestManager.config?.normalHeader
    private var privateEncoding: RequestUrlEncoding =  .queryString
    private var privateParameters: [String: Any]?
    private var privateFormData: [MJUploadFile]?
    private var privateData: Data? = nil
    
    
    private lazy var provider = {
       return MoyaProvider<MJRequest>(plugins: MJRequestManager.plugins)
    }()
    
    public init(host: String, path: String, formData: [MJUploadFile], parameters: [String: Any]?,header: [String: String]? = nil) {
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
    ///   - parameters: 请求参数
    ///   - data: 请求参数 优先级最高
    ///   - header: 请求头
    ///   - encoding: 编码方式
    public init(method: Moya.Method = .post, host: String, path: String, parameters: [String: Any]?,data: Data? = nil, header: [String: String]? = nil, encoding: RequestUrlEncoding =  .queryString) {
        super.init()
        privateMethod = method
        privateHost = host
        privatePath = path
        privateData = data
        privateParameters = parameters
        privateHeaders = header ?? MJRequestManager.config?.normalHeader
        if encoding == .jsonEncoding, let _parameters = parameters {
            if let jsonData = jsonToData(jsonDic: _parameters) {
                privateData = jsonData
            }
        }
        privateEncoding = encoding
    }
    
    public func execute<T: Codable>(result: T.Type, completion:@escaping ((_ result: T?, _ error: MJResponseError?) -> Void)) {
        
        provider.request(self, callbackQueue: nil, progress: nil) { (_result) in
            switch _result {
            case let .success(response):
                do {
                    let model = try response.decodeJSON(from: result.self)
                    completion(model,nil)
                } catch let error {
                    completion(nil,(error as! MJResponseError))
                }
            case let .failure(error):
                completion(nil,MJResponseError.http(error.errorCode, error.errorDescription ?? "未知"))
            }
        }
    }
    
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
        return URL(string:  "\(MJRequestManager.config?.agreement ?? "https")://\(privateHost)\(MJRequestManager.config?.domainDot ?? "")" )!
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
        if privateEncoding == .jsonEncoding {
            privateHeaders?["Content-type"] = "application/json"
        }
        return privateHeaders
    }
    
    /// 超时时间
    public var timeoutInterval: Int {
        return 15
    }
    
    /// 请求任务
    public var task: Task {
        /// 自定义请求
        if let _privateData = privateData  {
            return .requestData(_privateData)
        }
        /// 资源上传
        if let files = privateFormData, files.count > 0 {
            var datas: [MultipartFormData] = []
            for file in files {
                switch file {
                case let .image(data, paramName, fileName, mimeType):
                    print(data.base64EncodedString())
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
            return .requestParameters(parameters: parameters, encoding: privateEncoding.encoding)
        } else {
            return .requestParameters(parameters: parameters, encoding: privateEncoding.encoding)
        }
    }
    
    
    private func jsonToData(jsonDic: [String: Any]) -> Data? {
        if (!JSONSerialization.isValidJSONObject(jsonDic)) {
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        return data
    }
}
