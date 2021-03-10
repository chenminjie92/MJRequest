//
//  MJHttpConfig.swift
//  MJRequest
//
//  Created by chenminjie on 2021/3/10.
//

import Foundation
import Moya

public class MJRequestManager {
    
    /// 插件列表
    public static var plugins: [PluginType] = []
    /// 基本配置
    public static var config: MJHttpConfig?
    
    public static func setup(_ config: MJHttpConfig) {
        self.config = config
    }
}

public class MJHttpConfig {
    
    /// 协议
    public var agreement: String = "https"
    /// 尾部
    public var domainDot: String = ""
    /// 默认请求头
    public var normalHeader: [String : String]
    /// 是否打印
    public var logEnable: Bool = false
    
    //网络请求的打印端口
    public var output: (String) -> Void = { message in
        print(message)
    }
    
    //网络请求失败的统一处理，特殊界面处理可以再请求方法的onRequestFail中进行
    public var onRequestFail: (Error) -> Void = { error in
        
    }
    
    public init(agreement: String, domainDot: String = "", normalHeader: [String: String] = [:], logEnable: Bool = false) {
        self.agreement = agreement
        self.domainDot = domainDot
        self.normalHeader = normalHeader
        self.logEnable = logEnable
    }
}

/// 上传数据类，目前支持媒体文件和图片文件
public enum MJUploadFile {
    case media(url: URL, paramName: String, fileName: String)
    case image(data: Data, paramName: String, fileName: String, mimeType: String)
}
