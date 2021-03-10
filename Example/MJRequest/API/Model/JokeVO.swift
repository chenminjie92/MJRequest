//
//  JokeVO.swift
//  MJRequest_Example
//
//  Created by chenminjie on 2021/3/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

struct JokeVO: Codable {
    
    /// id
    let sid: String?
    /// 文本
    let text: String?
    /// 类型
    let type: String?
    /// 缩略图
    let thumbnail: String?
    /// 视频
    let video: String?
    /// 用户id
    let uid: String?
    /// 用户名
    let name: String?
    let header: String?
    let top_comments_content: String?
    let top_comments_voiceuri: String?
    let top_comments_uid: String?
    let top_comments_name: String?
    let top_comments_header: String?
    let passtime: String?
}
